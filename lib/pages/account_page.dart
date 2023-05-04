import 'package:catnizer/componenets/top_portion.dart';
import 'package:catnizer/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../componenets/list_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    child: Text(FirebaseAuth.instance.currentUser?.email ?? 'No user logged in',
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
                        onPressed: () {
                          showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MyHomePage()),
                                      );
                                    }
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        elevation: 0,
                        heroTag: "logout",
                        label: const Text("Logout"),
                        icon: const Icon(Icons.logout_outlined),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {
                          showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text('Are you sure you want to delete your account? You cannot undo this operation.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final user = FirebaseAuth.instance.currentUser;
                                    final instance = FirebaseFirestore.instance;
                                    final batch = instance.batch();
                                    var collection = instance.collection(user!.uid);
                                    var snapshots = await collection.get();
                                    for (var doc in snapshots.docs) {
                                      batch.delete(doc.reference);
                                    }
                                    await batch.commit();
                                    await user.delete();
                                    
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MyHomePage()),
                                      );
                                    }
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        elevation: 0,
                        heroTag: "delete",
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