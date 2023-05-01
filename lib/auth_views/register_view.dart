//Register View
import 'package:catnizer/bloc_state/bloc_register_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../firebase_options.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
      appBar: AppBar(title: const Text('Register'),),
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
                  BlocConsumer<SignUpStateBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterStateInitial) {} 
                      else if (state is RegisterStateDone) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Registered!'),
                            content: Text('You have registered using ${state.email}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => const LoginView()));
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          )
                        );
                      }
                      else if (state is RegisterStateError) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(state.error.dialogTitle),
                            content: Text(state.error.dialogText),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
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
                        BlocProvider.of<SignUpStateBloc>(context).signUp(email, password);
                      }, 
                      child: const Text('Register'),
                      );
                    }
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