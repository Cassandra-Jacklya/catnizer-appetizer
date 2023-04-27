import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'CatCatalog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'fav_page.dart';
import 'cat_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CATNIZER',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme:  const AppBarTheme(color: Color.fromARGB(255, 255, 160, 65)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Color.fromARGB(255, 154, 87, 20),
          selectedItemColor: Color.fromARGB(255, 255, 160, 65),
          )
      ),
      home: const CatCatalogue(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> images = [
    'assets/catimage/1.png',
    'assets/catimage/2.png',
    'assets/catimage/3.png',
    'assets/catimage/7.png',
  ];
  String _catFact = '';
  Timer? _timer;

  Future<String> _getCatFact() async {
    var response = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['fact'];
    } else {
      throw Exception('Failed to load cat fact');
    }
  }

  void _updateCatFact() {
    _getCatFact().then((value) {
      setState(() {
        _catFact = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateCatFact();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateCatFact();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("CATNIZER",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        fontSize: 60,
                        color: Color.fromRGBO(242, 140, 40, 100))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("Find Your Match Now!",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color.fromRGBO(110, 56, 2, 0.612)))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: CarouselSlider(
              items: images
                  .map((item) => Center(
                          child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: 1000,
                      )))
                  .toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => setState(() => _current = entry.key),
                child: Container(
                  width: 10,
                  height: 10,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? const Color.fromRGBO(240, 140, 40, 100)
                        : Colors.grey.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Flexible(
            child: Container(
              
              padding: const EdgeInsets.fromLTRB(10,10,10,10),
              child: Text(_catFact,
                
                style: const TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'Raleway',
                  color: Color.fromARGB(255, 190, 92, 12),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ],)
          
        ]));

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      //   Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //       pageBuilder: (context, anim1, anim2) => const CatCatalog(),
      //       transitionDuration: Duration.zero),
      // );
        break;
      case 1:
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page"),),
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
    );
  }
}
