import 'CatCatalog.dart';
import 'fav_page.dart';
import 'main.dart';
import 'cat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );


class CatDetails extends StatefulWidget {
  const CatDetails({super.key, required this.cat});

  final Cat cat;

  @override
  State<CatDetails> createState() => _CatDetailsState();
}

class _CatDetailsState extends State<CatDetails> {

  int _selectedIndex = 1;

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
      appBar: AppBar(title: const Text("Details")),
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
        child: Column(
          children: [
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // Set the clip behavior of the card
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // Define the child widgets of the card
                  child: Image.network(widget.cat.imageLink.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Name: "),
                  Text(widget.cat.name ?? ''),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bio: "),
                  Text(widget.cat.origin ?? ''),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Add to Favourites"),
                  IconButton(
                    onPressed: () {}, 
                    icon: const FaIcon(FontAwesomeIcons.heartCirclePlus)),
                ],
              ),
            ),
          ],)
      ),
    );
  }
}