import 'package:catnizer/bloc_state/bloc_favourite.dart';
import 'package:catnizer/cat.dart';
import 'package:catnizer/cat_details.dart';
import 'package:catnizer/componenets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
//unused cat catalog, so remove
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//unused awesome flutter, so remove
//unused main page, so remove

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  late FirebaseFirestore firebaseFirestore;
  late final user;

  @override
  void initState() {
    firebaseFirestore = FirebaseFirestore.instance;
    user = FirebaseAuth.instance.currentUser;
    BlocProvider.of<FavouriteBloc>(context).alreadyAdded(user?.uid ?? ' ', ' ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Favourites",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(30)))),
      bottomNavigationBar: const CustomNavigationBar(index: 2),
      body: BlocBuilder<FavouriteBloc, FavouriteEvent>(
        builder: (context, state) {
          if (state is FavouriteTrue) {
            return FutureBuilder<QuerySnapshot>(
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => CatDetails(cat: Cat(
                                userId: data[i]['userId'].toString(), 
                                name: data[i]['name'].toString(), 
                                origin: data[i]['origin'].toString(), 
                                imageLink: data[i]['imageLink'].toString(), 
                                length: data[i]['length'].toString(), 
                                minWeight: data[i]['minWeight'], 
                                maxWeight: data[i]['maxWeight'], 
                                minLifeExpectancy: data[i]['minLifeExpectancy'], 
                                maxLifeExpectancy: data[i]['maxLifeExpectancy'], 
                                playfulness: data[i]['playfulness'], 
                                familyFriendly: data[i]['familyFriendly'], 
                                grooming: data[i]['grooming']) )));
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [AspectRatio(
                                aspectRatio: 1.4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: data[i]['imageLink'].toString(),
                                    fit: BoxFit.cover,
                                    ),
                                ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Text(
                                    data[i]['name'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontSize: 24
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              }
            );
          }
          else if (state is FavouriteFalse && user != null) {
            return FutureBuilder<QuerySnapshot>(
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => CatDetails(cat: Cat(
                                userId: data[i]['userId'].toString(), 
                                name: data[i]['name'].toString(), 
                                origin: data[i]['origin'].toString(), 
                                imageLink: data[i]['imageLink'].toString(), 
                                length: data[i]['length'].toString(), 
                                minWeight: data[i]['minWeight'], 
                                maxWeight: data[i]['maxWeight'], 
                                minLifeExpectancy: data[i]['minLifeExpectancy'], 
                                maxLifeExpectancy: data[i]['maxLifeExpectancy'], 
                                playfulness: data[i]['playfulness'], 
                                familyFriendly: data[i]['familyFriendly'], 
                                grooming: data[i]['grooming']) )));
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [AspectRatio(
                                aspectRatio: 1.4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: data[i]['imageLink'].toString(),
                                    fit: BoxFit.cover,
                                    ),
                                ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Text(
                                    data[i]['name'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontSize: 24
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              }
            );
          }
          else {
            return Container();
          }
        }
      ),
    );
  }
}