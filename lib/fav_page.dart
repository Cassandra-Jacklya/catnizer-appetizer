import 'package:catnizer/CatCatalog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

    int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const CatCatalogue(),
            transitionDuration: Duration.zero),
      );
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
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(title: const Text("Favourites"),)),
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
          unselectedItemColor: const Color.fromARGB(255, 154, 87, 20),
          selectedItemColor: const Color.fromARGB(255, 255, 160, 65),
        ),
      body: Center(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                
              }),
          ),
          Container(
            height: 100,
            width: 100,
            color: Colors.amber,
          ),
        ],)
      ),
    );
  }
}