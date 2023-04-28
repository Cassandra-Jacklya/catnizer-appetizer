//Login View
import 'package:catnizer/auth_views/register_view.dart';
import 'package:catnizer/componenets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform
              ,),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter your email here",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter password",
                    ),
                  ),
                  TextButton(onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        print('Wrong password');
                      } else if (e.code == 'user-not-found') {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Error found'),
                            content: const Text('Wrong Password'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          )
                        );
                      }
                      else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Error found'),
                            content: const Text('User not found. Please sign up or recheck your credentials.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => const RegisterView()));
                                }, 
                                child: const Text("Sign Up")),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          )
                        );
                      }
                    }
                  }, 
                  child: const Text('Login'),
                  ),
                ],
              );
            default: 
              return const Text("Loading...");
          }
          
        },
      ),
    );
  }
}