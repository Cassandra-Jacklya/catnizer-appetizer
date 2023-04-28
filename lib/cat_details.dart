import 'package:cloud_firestore/cloud_firestore.dart';
import 'CatCatalog.dart';
import 'fav_page.dart';
import 'main.dart';
import 'cat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CatDetails extends StatefulWidget {
  const CatDetails({super.key, required this.cat});

  final Cat cat;

  @override
  State<CatDetails> createState() => _CatDetailsState();
}

class _CatDetailsState extends State<CatDetails> {

  int _selectedIndex = 1;
  CollectionReference cats = FirebaseFirestore.instance.collection("cats");

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

  Future<void> addFavourite(Cat cat) {
    return cats.add({
      'name': cat.name,
      'origin': cat.origin,
      'imageLink': cat.imageLink,
      'length': cat.length,
      'minWeight': cat.minWeight,
      'maxWeight': cat.maxWeight,
      'minLifeExpectancy': cat.minLifeExpectancy,
      'maxLifeExpectancy': cat.maxLifeExpectancy,
      'playfulness': cat.playfulness,
      'familyFriendly': cat.familyFriendly,
      'grooming': cat.grooming,
    })
    .then((value) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: "${cat.name} added to favourites!", 
          message: "Meow! Couldn't add me to favourites :(", 
          contentType: ContentType.success,
          color: const Color.fromARGB(255, 154, 87, 20),
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }).catchError((onError) {
      print(onError);
    });
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
                    onPressed: () {
                      addFavourite(widget.cat);
                    },
                    icon: const FaIcon(FontAwesomeIcons.heartCirclePlus)),
                ],
              ),
            ),
          ],)
      ),
    );
  }
}