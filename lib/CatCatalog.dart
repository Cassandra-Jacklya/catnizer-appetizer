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

  Future<List<Cat>> fetchCat() async {
    final catCatalogue = <Cat>[];
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
            name: cats['name'],
            origin: cats['origin'],
            imageLink: cats['image_link'],
            length: cats['length'],
            minWeight: cats['min_weight'],
            maxWeight: cats['max_weight'],
            minLifeExpectancy: cats['min_life_expectancy'],
            maxLifeExpectancy: cats['max_life_expectancy'],
            playfulness: cats['playfulness'],
            familyFriendly: cats['family_friendly'],
            grooming: cats['grooming']));
      }
    } else {
      throw Exception('Failed to fetch data from the API');
    }
    _currentOffset += 20;
    return catCatalogue;
  }
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

  final _fetchCat = FetchCat();
  final _cat = <Cat>[];
  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore();
  }

  void _loadMore() {
    _isLoading = true;
    _fetchCat.fetchCat().then((List<Cat> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _cat.addAll(fetchedList);
        });
      }
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
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: _hasMore ? _cat.length + 1 : _cat.length,
              itemBuilder: (BuildContext context, int index) {
                if (index >= _cat.length) {
                  if (!_isLoading) {
                    _loadMore();
                  }
                  return const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final cat = _cat[index];
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
                            color: const Color.fromRGBO(250, 200, 152, 100),
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
                                      cat.name.toString(),
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
            ),
          ),
        ],
      ),
    );
  }
}
