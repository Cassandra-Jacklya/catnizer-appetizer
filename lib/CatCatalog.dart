import 'package:firebase_auth/firebase_auth.dart';
import 'cat_details.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'cat.dart';
import 'fav_page.dart';
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => const MyHomePage(),
              transitionDuration: Duration.zero),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => const FavPage(),
              transitionDuration: Duration.zero),
        );
        break;
      default:
    }
  }

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
    switch (sortOption) {
      case 'clear':
        _catCatalogue.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
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
        title: const Text('Cat Catalogue'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cat),
            label: 'Cats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.heart),
            label: 'Likes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              _runFilter(value);
            },
            decoration: InputDecoration(
                labelText: 'Search for cat here...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
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
                    child: Text('Clear')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('playful');
                    },
                    child: Text('Playful')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('friendly');
                    },
                    child: Text('Friendly')),
                OutlinedButton(
                    onPressed: () {
                      _sortFunction('groom');
                    },
                    child: Text('Groom')),
              ],
            ),
          ),
          Expanded(
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
                          Expanded(
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
                                  color:
                                      const Color.fromRGBO(250, 200, 152, 100),
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: cat.imageLink.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${cat.name.toString()}\n'
                                            'Playful: ${cat.playfulness}\n'
                                            'Friendly: ${cat.familyFriendly}\n'
                                            'Groom: ${cat.grooming}',
                                            style: const TextStyle(
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
                        ],
                      );
                    },
                  )
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
