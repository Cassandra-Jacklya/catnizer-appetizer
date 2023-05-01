import '../CatCatalog.dart';
import '../fav_page.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  final String title;
  final Widget icon;

  const CustomListTile({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ListTile(
        title: Text(title),
        leading: icon,
        trailing: const Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          if (title == "Favourite Cats") {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const FavPage()));
          }
          else if (title == "All Cats") {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const CatCatalogue()));
          }
        },
      ),
    );
  }
}