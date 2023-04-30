import 'package:firebase_auth/firebase_auth.dart';
import 'package:transparent_image/transparent_image.dart';
import 'CatCatalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  late FirebaseFirestore firebaseFirestore;
  late final user;
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
  void initState() {
    firebaseFirestore = FirebaseFirestore.instance;
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(title: const Text("Meow Favourites"),)),
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
      body: FutureBuilder<QuerySnapshot>(
        future: firebaseFirestore.collection(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> data = snapshot.data!.docs;

              return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Card(
                      color: Colors.blueGrey[200],
                      elevation: 10.0,
                      surfaceTintColor: Colors.amber[200],
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.4,
                              child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: data[i]['imageLink'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(data[i]['name'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          }
          return const Text("Loading");
        }
      ),
    );
  }
}