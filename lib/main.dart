import 'package:flutter/material.dart';
import 'FavPage.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
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