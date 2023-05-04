import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/cat_catalog.dart';
import '../pages/fav_page.dart';
import '../main.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.index});

  final int index;

  @override
  State<CustomNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<CustomNavigationBar> {

  void _onItemTapped(int index) {
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
    return BottomNavigationBar(
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
      currentIndex: widget.index,
      onTap: _onItemTapped,
      unselectedItemColor: const Color.fromARGB(255, 154, 87, 20),
      selectedItemColor: const Color.fromARGB(255, 255, 160, 65)
    );
  }
}