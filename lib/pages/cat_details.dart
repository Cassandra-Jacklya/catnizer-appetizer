import 'package:catnizer/bloc_state/bloc_favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/cat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../componenets/nav_bar.dart';

class CatDetails extends StatefulWidget {
  const CatDetails({super.key, required this.cat});

  final Cat cat;

  @override
  State<CatDetails> createState() => _CatDetailsState();
}

class _CatDetailsState extends State<CatDetails> {
  Future<void> addFavourite(Cat cat) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    try {
      return FirebaseFirestore.instance.collection(uid!).doc(cat.name).set({
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
      }).then((value) {
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
    } on FirebaseAuthException catch (e) {
      //for developers
      print("Error: ${e.code}");
    }
  }

  void removeFavourites(Cat cat) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      db.collection(cat.userId!).doc(cat.name).delete().then((value) {
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
    } on FirebaseException catch (e) {
      //for developers
      print("Error: ${e.code}");
    }
  }

  @override
  void initState() {
    BlocProvider.of<FavouriteBloc>(context)
        .alreadyAdded(widget.cat.userId, widget.cat.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Details",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(30)))),
      bottomNavigationBar: const CustomNavigationBar(index: 0),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ClipRRect(
              child: Image.network(
                widget.cat.imageLink.toString(),
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 1.0,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 157, 44),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5,
                                  width: 35,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.cat.name ?? '',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Origin: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                          Text(widget.cat.origin ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Raleway',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    BlocBuilder<FavouriteBloc, FavouriteEvent>(
                                        builder: (context, state) {
                                  if (state is FavouriteLoading) {
                                    return const CircularProgressIndicator();
                                  } else if (state is FavouriteTrue) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              removeFavourites(widget.cat);
                                              BlocProvider.of<FavouriteBloc>(
                                                      context)
                                                  .alreadyAdded(
                                                      widget.cat.userId,
                                                      widget.cat.name);
                                            },
                                            icon: const FaIcon(FontAwesomeIcons
                                                .heartCircleMinus)),
                                      ],
                                    );
                                  } else if (state is FavouriteFalse) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            addFavourite(widget.cat);
                                            BlocProvider.of<FavouriteBloc>(
                                                    context)
                                                .alreadyAdded(widget.cat.userId,
                                                    widget.cat.name);
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.heartCirclePlus),
                                        ),
                                      ],
                                    );
                                  } else if (state is FavouriteError) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const FaIcon(FontAwesomeIcons
                                              .triangleExclamation),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ),
                            Row(
                              children: const [],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Row(
                          children: const [
                            Text("Life Expectancy:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Text(
                                (widget.cat.minLifeExpectancy)!
                                    .toInt()
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                            const Text(" to ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                            Text(
                                (widget.cat.maxLifeExpectancy)!
                                    .toInt()
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                            const Text(" Years ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  child: Row(
                                    children: const [
                                      Text("Weight",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                          (widget.cat.minWeight)!
                                              .toInt()
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                      const Text(" to ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                      Text(
                                          (widget.cat.maxWeight)!
                                              .toInt()
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                      const Text(" KG ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                            child: VerticalDivider(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: Row(
                                  children: const [
                                    Text("Length",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    Text((widget.cat.length.toString()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "PLAYFUL",
                                      style: TextStyle(
                                          fontFamily: "Raleway",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: RatingBar.builder(
                                          initialRating:
                                              (widget.cat.playfulness)!
                                                  .toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          ignoreGestures: true,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "FRIENDLY",
                                      style: TextStyle(
                                          fontFamily: "Raleway",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: RatingBar.builder(
                                          initialRating:
                                              (widget.cat.familyFriendly)!
                                                  .toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          ignoreGestures: true,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "GROOMING",
                                      style: TextStyle(
                                          fontFamily: "Raleway",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: RatingBar.builder(
                                          initialRating:
                                              (widget.cat.grooming)!.toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          ignoreGestures: true,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
