import 'cat_details.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'cat.dart';
import 'fav_page.dart';

Future<List<Cat>> fetchCat() async {
  int pageNumber = 0;
  final catCatalogue = <Cat>[];
  while (pageNumber <= 5) {
    final response = await http.get(
      Uri.parse(
          'https://api.api-ninjas.com/v1/cats?min_weight=1&offset=$pageNumber'),
      headers: {
        'X-Api-Key': 'ZzQZjINuJDLyWUNYiJ1QYQ==hiuvuUGzKSpCkJmY',
      },
    );
    if (response.statusCode == 200) {
      final catCatalogueData = jsonDecode(response.body);
      print(catCatalogueData);
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
    pageNumber++;
  }
  return catCatalogue;
}



class CatCatalogue extends StatefulWidget {
  const CatCatalogue({super.key});

  @override
  State<CatCatalogue> createState() => _CatCatalogue();
}

class _CatCatalogue extends State<CatCatalogue> {
  late Future<List<Cat>> _cat;


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
  
  @override
  void initState() {
    super.initState();
    _cat = fetchCat();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cat Catalogue'),
        ),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
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
        body: FutureBuilder<List<Cat>>(
          future: _cat,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final cats = snapshot.data!;
              return ListView.builder(
                itemCount: cats.length,
                itemBuilder: (BuildContext context, int index) {
                  final cat = cats[index];
                  return ListTile(
                    leading: Image.network(cat.imageLink.toString()),
                    title: Text(cat.name.toString()),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Origin: ${cat.origin}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatDetails(cat: cat),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
