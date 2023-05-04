import 'package:catnizer/componenets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cat_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/cat.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  String _sortState = '';
  var _controller = TextEditingController();
  bool _isFetching = true;

  void clearText() {
    _controller.clear();
  }

  @override
  void initState() {
    _fetchCats();
    _sortState = 'clear';
    super.initState();
  }

  Future<void> _fetchCats() async {
    final catCatalogue = await _fetchCat.fetchCat();
    if (mounted) {
      setState(() {
        _catCatalogue = catCatalogue;
        _chosenCat = _catCatalogue;
        _isFetching = false;
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
      case 'playfulness':
        _catCatalogue
            .sort((b, a) => (a.playfulness ?? 0).compareTo(b.playfulness ?? 0));
        break;
      case 'familyFriendly':
        _catCatalogue.sort(
            (b, a) => (a.familyFriendly ?? 0).compareTo(b.familyFriendly ?? 0));
        break;
      case 'grooming':
        _catCatalogue
            .sort((b, a) => (a.grooming ?? 0).compareTo(b.grooming ?? 0));
        break;
    }
    setState(() {
      _chosenCat = _catCatalogue;
      _sortState = sortOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: TextField(
                controller: _controller,
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
                        clearText();
                        _sortFunction('clear');
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _sortState == 'clear'
                                  ? const Color.fromRGBO(255, 145, 0, 1)
                                  : const Color.fromRGBO(215, 215, 215, 1))),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                            color: _sortState == 'clear'
                                ? const Color.fromRGBO(255, 145, 0, 1)
                                : Colors.black54),
                      )),
                  OutlinedButton(
                      onPressed: () {
                        clearText();
                        _sortFunction('playfulness');
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _sortState == 'playfulness'
                                  ? const Color.fromRGBO(255, 145, 0, 1)
                                  : const Color.fromRGBO(215, 215, 215, 1))),
                      child: Text(
                        'Playful',
                        style: TextStyle(
                            color: _sortState == 'playfulness'
                                ? const Color.fromRGBO(255, 145, 0, 1)
                                : Colors.black54),
                      )),
                  OutlinedButton(
                      onPressed: () {
                        clearText();
                        _sortFunction('familyFriendly');
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _sortState == 'familyFriendly'
                                  ? const Color.fromRGBO(255, 145, 0, 1)
                                  : const Color.fromRGBO(215, 215, 215, 1))),
                      child: Text(
                        'Friendly',
                        style: TextStyle(
                            color: _sortState == 'familyFriendly'
                                ? const Color.fromRGBO(255, 145, 0, 1)
                                : Colors.black54),
                      )),
                  OutlinedButton(
                      onPressed: () {
                        clearText();
                        _sortFunction('grooming');
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _sortState == 'grooming'
                                  ? const Color.fromRGBO(255, 145, 0, 1)
                                  : const Color.fromRGBO(215, 215, 215, 1))),
                      child: Text(
                        'Groom',
                        style: TextStyle(
                            color: _sortState == 'grooming'
                                ? const Color.fromRGBO(255, 145, 0, 1)
                                : Colors.black54),
                      )),
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
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                    'assets/catimage/cat-running.gif',
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
                                                  fontFamily: 'RaleWay',
                                                  color: Color.fromRGBO(
                                                      255, 145, 0, 0.979),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: _sortState == 'clear'
                                                      ? false
                                                      : true,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5.0),
                                                    child: Text(
                                                      _sortState == 'playfulness'
                                                          ? 'Playful: '
                                                          : _sortState ==
                                                                  'familyFriendly'
                                                              ? 'Friendly: '
                                                              : _sortState ==
                                                                      'grooming'
                                                                  ? 'Grooming: '
                                                                  : 'Something went wrong!',
                                                      style: const TextStyle(
                                                        fontFamily: 'Raleway',
                                                        color: Color.fromRGBO(
                                                            255, 145, 0, 0.979),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _sortState == 'clear'
                                                      ? false
                                                      : true,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5.0),
                                                    child: RatingBar.builder(
                                                      initialRating: _sortState ==
                                                              'playfulness'
                                                          ? cat.playfulness
                                                              .toDouble()
                                                          : _sortState ==
                                                                  'familyFriendly'
                                                              ? cat.familyFriendly
                                                                  .toDouble()
                                                              : _sortState ==
                                                                      'grooming'
                                                                  ? cat.grooming
                                                                      .toDouble()
                                                                  : 0,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 15,
                                                      ignoreGestures: true,
                                                      itemBuilder: (context, _) =>
                                                          const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                  : _isFetching
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Text(
                                'Please wait while the cat is fetching the API...',
                                textAlign: TextAlign.center,
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
                                  'assets/catimage/cat-running.gif',
                                  height: 200,
                                ),
                              ),
                            )
                          ],
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
                                  height: 150,
                                ),
                              ),
                            )
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
