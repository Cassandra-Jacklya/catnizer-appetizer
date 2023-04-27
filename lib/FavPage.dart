import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(title: const Text("Favourites"),)),
      body: Center(
        child: Column(children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                ),
            ])
        ],)
      ),
    );
  }
}