//Login View
import 'package:catnizer/bloc_state/bloc_auth.dart';
import 'package:catnizer/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_view.dart';
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
                  //continue here
                  BlocConsumer<LoginStateBloc, LoginState>(
                    listener: (context, state) {
                      if (state is AppStateInitial) {}
                        else if (state is AppStateLoggedIn) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Login Successful!'),
                                content: Text('You are logged in as ${state.email}'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, 
                                      MaterialPageRoute(builder: (context) => const MyHomePage()));
                                    },
                                    child: const Text('Go to home page'),
                                  ),
                                ],
                              )
                            );
                        }
                        else if (state is AppStateError) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(state.error.dialogTitle),
                                content: Text(state.error.dialogText),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (context) => const RegisterView()));
                                    },
                                    child: const Text("Sign Up"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              )
                            );
                          }
                      },
                      builder: (context, state) {
                        return TextButton(onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          BlocProvider.of<LoginStateBloc>(context).initFirebase(email, password);
                        }, 
                        child: const Text("Login"),
                      );
                    }
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const RegisterView()));
                    },
                    child: const Text("Not yet registered? Sign up now!"))
                ],
              );
            default: 
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}