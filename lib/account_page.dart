import 'package:catnizer/componenets/top_portion.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'componenets/list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Flexible(flex: 2, child: TopPortion()),
          Flexible(flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Email',
                      style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'logout',
                        elevation: 0,
                        label: const Text("Logout"),
                        icon: const Icon(Icons.logout_outlined),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'delete',
                        elevation: 0,
                        backgroundColor: Colors.redAccent,
                        label: const Text("Delete"),
                        icon: const Icon(Icons.warning_amber),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 4),
                    child: CustomListTile(
                      title: "Favourite Cats", icon: FaIcon(FontAwesomeIcons.heart)),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: CustomListTile(
                      title: "All Cats", icon: FaIcon(FontAwesomeIcons.solidNoteSticky)),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}