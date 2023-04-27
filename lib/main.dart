import 'package:flutter/material.dart';
import 'fav_page.dart';
import 'cat_details.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:  const AppBarTheme(color: Color.fromARGB(255, 255, 160, 65)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Color.fromARGB(255, 154, 87, 20),
          selectedItemColor: Color.fromARGB(255, 255, 160, 65),
          )
      ),
      home: const CatDetails(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page"),),
    );
  }
}