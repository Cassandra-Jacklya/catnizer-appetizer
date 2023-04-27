import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// import 'cat_details.dart';
import 'dart:io';

Future<List<Cat>> fetchCat() async {
  int pageNumber = 0;
  final catCatalogue = <Cat>[];
  while (pageNumber <= 2) {
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

class Cat {
  final String? name;
  final String? origin;
  final String? imageLink;
  final String? length;
  final num? minWeight;
  final num? maxWeight;
  final num? minLifeExpectancy;
  final num? maxLifeExpectancy;
  final num? playfulness;
  final num? familyFriendly;
  final num? grooming;
  const Cat(
      {required this.name,
      required this.origin,
      required this.imageLink,
      required this.length,
      required this.minWeight,
      required this.maxWeight,
      required this.minLifeExpectancy,
      required this.maxLifeExpectancy,
      required this.playfulness,
      required this.familyFriendly,
      required this.grooming});
}

class CatCatalogue extends StatefulWidget {
  const CatCatalogue({super.key});

  @override
  State<CatCatalogue> createState() => _CatCatalogue();
}

class _CatCatalogue extends State<CatCatalogue> {
  late Future<List<Cat>> _cat;

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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CatDetails(cat: cat),
                      //   ),
                      // );
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
