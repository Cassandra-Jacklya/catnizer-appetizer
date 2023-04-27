import 'package:flutter/material.dart';
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
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                
              }),
          ),
          BottomNavigationBar(
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
            ])
        ],)
      ),
    );
  }
}