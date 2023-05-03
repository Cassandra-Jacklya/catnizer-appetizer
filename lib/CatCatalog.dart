import 'package:catnizer/componenets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cat_details.dart';
//unused main page, so remove
import 'package:flutter/material.dart';
//unused awesome snack bar, so remove
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'cat.dart';
//unused fav page, so remove
import 'package:transparent_image/transparent_image.dart';

class FetchCat {
  int _currentOffset = 0;
  final catCatalogue = <Cat>[];

  Future<List<Cat>> fetchCat() async {
    while (_currentOffset <= 80) {
      final response = await http.get(
        Uri.parse(
            'https://api.api-ninjas.com/v1/cats?min_weight=1&offset=$_currentOffset'),
        headers: {
          'X-Api-Key': 'ZzQZjINuJDLyWUNYiJ1QYQ==hiuvuUGzKSpCkJmY',
        },
      );
      if (response.statusCode == 200) {
        final catCatalogueData = jsonDecode(response.body);
        for (final cats in catCatalogueData) {
          catCatalogue.add(Cat(
              userId: FirebaseAuth.instance.currentUser?.uid,
              name: cats['name'] ?? 'Unknown',
              origin: cats['origin'] ?? 'Unknown',
              imageLink: cats['image_link'] ?? 'Unknown',
              length: cats['length'] ?? 'Unknown',
              minWeight: cats['min_weight'] ?? 0,
              maxWeight: cats['max_weight'] ?? 0,
              minLifeExpectancy: cats['min_life_expectancy'] ?? 0,
              maxLifeExpectancy: cats['max_life_expectancy'] ?? 0,
              playfulness: cats['playfulness'] ?? 0,
              familyFriendly: cats['family_friendly'] ?? 0,
              grooming: cats['grooming'] ?? 0));
        }
      } else {
        throw Exception('Failed to fetch data from the API');
      }
      _currentOffset += 20;
    }
    return catCatalogue;
  }

  List<Cat> getCatCatalogue() => catCatalogue;
}

class CatCatalogue extends StatefulWidget {
  const CatCatalogue({super.key});

  @override
  State<CatCatalogue> createState() => _CatCatalogue();
}

class _CatCatalogue extends State<CatCatalogue> {
  
  final FetchCat _fetchCat = FetchCat();
  List<Cat> _catCatalogue = [];
  var _chosenCat = [];

  @override
  void initState() {
    _fetchCats();
    super.initState();
  }

  Future<void> _fetchCats() async {
    final catCatalogue = await _fetchCat.fetchCat();
    if (mounted) {
      setState(() {
        _catCatalogue = catCatalogue;
        _chosenCat = _catCatalogue;
      });
    }
  }

  void _runFilter(String userInput) {
    var results = [];
    if (userInput.isEmpty) {
      results = _catCatalogue;
    } else {
      results = _catCatalogue
          .where((cat) =>
              cat.name!.toLowerCase().contains(userInput.toLowerCase()))
          .toList();
    }
    setState(() {
      _chosenCat = results;
    });
  }

  void _sortFunction(String sortOption) {
    _catCatalogue.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    switch (sortOption) {
      case 'clear':
        break;
      case 'playful':
        _catCatalogue
            .sort((b, a) => (a.playfulness ?? 0).compareTo(b.playfulness ?? 0));
        break;
      case 'friendly':
        _catCatalogue.sort(
            (b, a) => (a.familyFriendly ?? 0).compareTo(b.familyFriendly ?? 0));
        break;
      case 'groom':
        _catCatalogue
            .sort((b, a) => (a.grooming ?? 0).compareTo(b.grooming ?? 0));
        break;
    }
    setState(() {
      _chosenCat = _catCatalogue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Cat Catalogue",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(30)))),
      bottomNavigationBar: const CustomNavigationBar(index: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: TextField(
              onChanged: (value) {
                _runFilter(value);
              },
              decoration: InputDecoration(
                  labelText: 'Search for cat here...',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('clear');
                    },
                    child: const Text('Clear')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('playful');
                    },
                    child: const Text('Playful')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('friendly');
                    },
                    child: const Text('Friendly')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('groom');
                    },
                    child: const Text('Groom')),
              ],
            ),
          ),
          Flexible(
            child: _chosenCat.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: _chosenCat.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= _chosenCat.length) {
                        return const Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      var cat = _chosenCat[index];
                      return Column(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CatDetails(cat: cat),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 500,
                                height: 500,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.12),
                                        blurRadius: 1,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image:
                                                      cat.imageLink.toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              cat.name.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Raleway',
                                                color: Color.fromRGBO(
                                                    255, 145, 0, 0.979),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Text(
                          'No Meow Found !!!',
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Color.fromRGBO(255, 145, 0, 0.979)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: SizedBox(
                          child: Image.asset(
                            'assets/catimage/c3.png',
                            height: 200,
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
