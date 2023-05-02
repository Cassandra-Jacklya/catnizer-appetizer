import 'dart:convert';
import 'package:catnizer/account_page.dart';
import 'package:catnizer/auth_views/login_view.dart';
import 'package:catnizer/bloc_state/bloc_auth.dart';
import 'package:catnizer/bloc_state/bloc_favourite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'CatCatalog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bloc_state/bloc_register_auth.dart';
import 'fav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'bloc_state/bloc_main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
          create: (BuildContext context) {return LoginStateBloc();}
        ),
        BlocProvider(
          create: (BuildContext context) {return SignUpStateBloc();}
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  String catDesc = 'No description found.';
  late final AnimationController _animationController;
  final List<String> images = [
    'assets/catimage/f1.jpg',
    'assets/catimage/p2.jpg',
    'assets/catimage/p3.jpg',
  ];

  // List<dynamic> _articles = [];

  int _selectedIndex = 1;

  // Future<void> _fetchNews() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://newsapi.org/v2/everything?q=cat&apiKey=367dfcd1080549d4a7ec7e025e82fa3c'),
  //   );
  //   final jsonData = jsonDecode(response.body);
  //   setState(() {
  //     _articles = jsonData['articles'];
  //   });
  // }

  @override
  void initState() {
    BlocProvider.of<MainPageBloc>(context).getMainStuff();
    // _fetchNews();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                      options: DefaultFirebaseOptions.currentPlatform,
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          final User? user =
                              FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            return FadeTransition(
                              opacity: _animationController,
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView()));
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  242, 140, 40, 100))))),
                                child: const Text("Login")),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => const ProfilePage()));
                              }, 
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                        color: Color.fromRGBO(242, 140, 40, 100)
                                      )
                                    )
                                  )
                                ),
                              child: const Text('My Account')
                            );
                          }
                        default:
                          return FadeTransition(
                            opacity: _animationController,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView()));
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    242, 140, 40, 100))))),
                                child: const Text("Login")),
                          );
                      }
                    }
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/catimage/catlogo.png',
                    height: 35,
                  ),
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Image.asset('assets/catimage/left1.png',height: 10,),
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: BlocBuilder<MainPageBloc, MainPageEvent>(
                        builder: (context, state) {
                      if (state is MainPageLoaded) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text("FUN FACT",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Raleway',
                                    color: Color.fromRGBO(240, 140, 10, 100),
                                    fontWeight: FontWeight.w800,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                state.fact,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Raleway',
                                  color: Color.fromARGB(255, 190, 92, 12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (state is MainPageInitial) {
                        return Column(
                          children: const [
                            Text("FUN FACT",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  color: Color.fromRGBO(240, 140, 10, 100),
                                  fontWeight: FontWeight.w800,
                                )),
                            Text("purring...",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Raleway',
                                  color: Color.fromARGB(255, 190, 92, 12),
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        );
                      } else {
                        return const Text(
                            "Fun fact not loaded. Are you sure you love cats?",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ));
                      }
                    }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Image.asset('assets/catimage/right1.png',height: 10,),
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
                        color: Color.fromRGBO(240, 140, 10, 100)),
                  ),
                ),
              ],
            ),
            BlocBuilder<MainPageBloc, MainPageEvent>(
              builder: (context, state) {
                if (state is MainPageLoaded) {
                  return Column(
                    children: [
                      Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                      'PERSIAN',
                                      style: TextStyle(
                                          color: Color.fromRGBO(240, 140, 10, 100),
                                          fontFamily: 'Raleway',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    content: Text(
                                      state.persian,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(141, 81, 2, 0.612),
                                          fontFamily: 'Raleway',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text('OK')),
                                      ),
                                    ],
                                  )
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
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
                                        'PERSIAN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                      'RAGDOLL',
                                      style: TextStyle(
                                          color: Color.fromRGBO(240, 140, 10, 100),
                                          fontFamily: 'Raleway',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    content: Text(
                                      state.ragdoll,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(141, 81, 2, 0.612),
                                          fontFamily: 'Raleway',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text('OK')),
                                      ),
                                    ],
                                  )
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/ragdoll.jpg',
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
                                        'RAGDOLL',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'MAINE COON',
                                        style: TextStyle(
                                            color: Color.fromRGBO(240, 140, 10, 100),
                                            fontFamily: 'Raleway',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      content: Text(
                                        state.maincoon,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(141, 81, 2, 0.612),
                                            fontFamily: 'Raleway',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('OK')),
                                        ),
                                      ],
                                    )
                                  );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/maincoon.jpg',
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
                                        'MAINE COON',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'ABYSSINIAN',
                                        style: TextStyle(
                                            color: Color.fromRGBO(240, 140, 10, 100),
                                            fontFamily: 'Raleway',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      content: Text(
                                        state.aby,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(141, 81, 2, 0.612),
                                            fontFamily: 'Raleway',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('OK')),
                                        ),
                                      ],
                                    )
                                  );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/aby.jpg',
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
                                        'ABYSSINIAN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } 
                else {
                  return Column(
                    children: [
                      Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                      'PERSIAN',
                                      style: TextStyle(
                                          color: Color.fromRGBO(240, 140, 10, 100),
                                          fontFamily: 'Raleway',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    content: Text(
                                      catDesc,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(141, 81, 2, 0.612),
                                          fontFamily: 'Raleway',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text('OK')),
                                      ),
                                    ],
                                  )
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
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
                                        'PERSIAN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                      'RAGDOLL',
                                      style: TextStyle(
                                          color: Color.fromRGBO(240, 140, 10, 100),
                                          fontFamily: 'Raleway',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    content: Text(
                                      catDesc,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(141, 81, 2, 0.612),
                                          fontFamily: 'Raleway',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text('OK')),
                                      ),
                                    ],
                                  )
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/ragdoll.jpg',
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
                                        'RAGDOLL',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'MAINE COON',
                                        style: TextStyle(
                                            color: Color.fromRGBO(240, 140, 10, 100),
                                            fontFamily: 'Raleway',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      content: Text(
                                        catDesc,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(141, 81, 2, 0.612),
                                            fontFamily: 'Raleway',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('OK')),
                                        ),
                                      ],
                                    )
                                  );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/maincoon.jpg',
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
                                        'MAINE COON',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'ABYSSINIANs',
                                        style: TextStyle(
                                            color: Color.fromRGBO(240, 140, 10, 100),
                                            fontFamily: 'Raleway',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      content: Text(
                                        catDesc,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(141, 81, 2, 0.612),
                                            fontFamily: 'Raleway',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('OK')),
                                        ),
                                      ],
                                    )
                                  );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          'assets/catimage/aby.jpg',
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
                                        'ABYSSINIAN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }
                
            ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CatCatalogue()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(0, 40),
                      ),
                      child: const Text(
                        'MEOW',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 100),
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Row(
            // children:  [
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            //     child: Text(
            //    _persianDescription ??
            //                   'Loading description...'

            //     ),
            //   ),
            // ],

            //   children: const [
            //     Padding(
            //       padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
            //       child: Text(
            //         "Cat News",
            //         style: TextStyle(
            //             fontFamily: 'Raleway',
            //             fontWeight: FontWeight.w700,
            //             fontSize: 20,
            //             color: Color.fromRGBO(240, 140, 10, 100)),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(children: [
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: _articles.length,
            //       itemBuilder: (context, index) {
            //         final article = _articles[index];
            //         return ListTile(
            //           title: Text(article['title']),
            //           subtitle: Text(article['description']),
            //           leading: Image.network(article['urlToImage']),
            //           onTap: () {
            //             // Handle article selection
            //           },
            //         );
            //       },
            //     ),
            //   ),
            //   // add any widget as the last child here
            //   Container(
            //     height: 50,
            //     color: Colors.blue,
            //     child: const Center(
            //       child: Text('This is the last row'),
            //     ),
            //   ),
            // ]),
          ],
        )));
  }
}
