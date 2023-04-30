import 'package:catnizer/auth_views/login_view.dart';
import 'package:catnizer/bloc_state/bloc_auth.dart';
import 'package:catnizer/bloc_state/bloc_favourite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'CatCatalog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'fav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'bloc_state/bloc_main.dart';
import 'bloc_state/bloc_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {return MainPageBloc();}
        ),
        BlocProvider(
          create: (BuildContext context) {return FavouriteBloc();}
        ),
        BlocProvider(
          create: (BuildContext context) {return AppStateBloc();}
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CATNIZER',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            appBarTheme:
                const AppBarTheme(color: Color.fromARGB(255, 255, 160, 65)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedItemColor: Color.fromARGB(255, 154, 87, 20),
              selectedItemColor: Color.fromARGB(255, 255, 160, 65),
            )),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final List<String> images = [
    'assets/catimage/1.png',
    'assets/catimage/2.png',
    'assets/catimage/3.png',
    'assets/catimage/7.png',
  ];

  int _selectedIndex = 1;

  @override
  void initState() {
    BlocProvider.of<MainPageBloc>(context).getCatFact();
    super.initState();
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }

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

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 65, 20, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FutureBuilder(
                                future: Firebase.initializeApp(
                                  options: DefaultFirebaseOptions.currentPlatform,),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                    final User? user = FirebaseAuth.instance.currentUser;
                                      if (user == null) {
                                        return TextButton(
                                        onPressed: () async {
                                          Navigator.push(context, 
                                          MaterialPageRoute(builder: (context) => const LoginView()));
                                        }, 
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    242, 140, 40, 100))))),
                              child: const Text("Login"));
                            }
                            else {
                              return ElevatedButton(
                                onPressed: () {
                                
                                }, 
                                child: Text(user.email!));
                            }
                          default:
                            return ElevatedButton(
                              onPressed: () async {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => const LoginView()));
                              }, 
                              style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    242, 140, 40, 100))))),
                              child: const Text("Login"));
                        }
                        
                      }
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("CATNIZER",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            fontSize: 50,
                            color: Color.fromRGBO(242, 140, 40, 100))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("Find Your Match Now",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color.fromRGBO(110, 56, 2, 0.612)))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: CarouselSlider(
                  items: images
                      .map((item) => Center(
                              child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                          )))
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => setState(() => _current = entry.key),
                    child: Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? const Color.fromRGBO(240, 140, 40, 100)
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: BlocBuilder<MainPageBloc, MainPageEvent>(
                        builder: (context, state) {
                          if (state is MainPageLoaded) {
                            return Column(
                              children: [
                                const Text("Fun Fact:",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Raleway',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                Text(
                                  state.fact,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Raleway',
                                    color: Color.fromARGB(255, 190, 92, 12),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }
                          else if (state is MainPageInitial) {
                            return Column(
                              children: const [
                                Text("Fun Fact:",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Raleway',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                Text("purring...",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Raleway',
                                    color: Color.fromARGB(255, 190, 92, 12),
                                    fontWeight: FontWeight.w400,
                                  )
                                ),
                              ],
                            );
                          }
                          else {
                            return const Text("Fun fact not loaded. Are you sure you love cats?",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Raleway',
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              )
                            );
                          }
                        }
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                      "Most Popular Breeds",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color.fromRGBO(240, 140, 40, 100)),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48),
                            child: Image.asset(
                              'assets/catimage/persian.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Container(
                         
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Persian',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),

                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.5),
                    //       spreadRadius: 0,
                    //       blurRadius: 0,
                    //       offset: const Offset(20, 1), // changes position of shadow
                    //     ),
                    //   ],
                    // ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48), // Image radius
                        child: Image.asset(
                          'assets/catimage/ragdoll.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),

                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 0,
                      //       blurRadius: 0,
                      //       offset: const Offset(20, 1), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48), // Image radius
                          child: Image.asset('assets/catimage/maincoon.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),

                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 0,
                      //       blurRadius: 0,
                      //       offset: const Offset(20, 1), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48), // Image radius
                          child: Image.asset('assets/catimage/aby.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ])
      ),
    );
  }
}
