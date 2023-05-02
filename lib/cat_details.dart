import 'package:catnizer/bloc_state/bloc_favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> addFavourite(Cat cat) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid; 

    try {
      return FirebaseFirestore.instance.collection(uid!)
      .doc(cat.name)
      .set({
        'userId': uid,
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
            title: "${cat.name}", 
            message: "Added to favourites!", 
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
    } on FirebaseAuthException catch(e) {
      //for developers
      print("Error: ${e.code}");
    }
  }

  void removeFavourites(Cat cat) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      db.collection(cat.userId!)
        .doc(cat.name)
        .delete()
        .then((value) {
          final snackBar = SnackBar(
            content: AwesomeSnackbarContent(
              title: "${widget.cat.name}", 
              message: "Removed from favourites!", 
              contentType: ContentType.success,
              color: const Color.fromARGB(255, 154, 87, 20),
            ),
          );

          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        });
    } on FirebaseException catch(e) {
      //for developers
      print("Error: ${e.code}");
    }
  }

  @override
  void initState() {
    BlocProvider.of<FavouriteBloc>(context).alreadyAdded(widget.cat.userId, widget.cat.name);
    super.initState();
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
                  const Text("Origin: "),
                  Text(widget.cat.origin ?? ''),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<FavouriteBloc, FavouriteEvent>(
                builder: (context, state) {
                  print(widget.cat.userId);
                  print(widget.cat.name);
                  if (state is FavouriteLoading) {
                    return const CircularProgressIndicator();
                  }
                  else if (state is FavouriteTrue) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Remove from favourites"),
                        IconButton(
                          onPressed: () {
                            removeFavourites(widget.cat);
                            BlocProvider.of<FavouriteBloc>(context).alreadyAdded(widget.cat.userId, widget.cat.name);
                          }, 
                          icon: const FaIcon(FontAwesomeIcons.heartCircleMinus)
                        ),
                      ],
                    );
                  }
                  else if (state is FavouriteFalse) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Add to favourites"),
                        IconButton(
                          onPressed: () {
                            addFavourite(widget.cat);
                            BlocProvider.of<FavouriteBloc>(context).alreadyAdded(widget.cat.userId, widget.cat.name);
                          }, 
                          icon: const FaIcon(FontAwesomeIcons.heartCirclePlus),
                        ),
                      ],
                    );
                  }
                  else if (state is FavouriteError) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Meow! Can't seem to favourite cats now"),
                        IconButton(
                          onPressed: () {}, 
                          icon: const FaIcon(FontAwesomeIcons.triangleExclamation),
                        ),
                      ],
                    );
                    // return Align(
                    //   child: Text("Meow! Can't seem to favourite cats now",
                    //     style: TextStyle(fontWeight: FontWeight.w600,
                    //       color: Colors.red.shade900,
                    //       fontFamily: 'Raleway'
                    //     ),
                    //   )
                    // );
                  }
                  else {
                    //should never happen
                    return Container();
                  }
                }
              ),
            ),
          ],)
      ),
    );
  }
}