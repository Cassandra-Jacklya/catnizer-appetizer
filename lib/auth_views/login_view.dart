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

  //clean up 
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //sign in app bar
      appBar: AppBar(   
        centerTitle: true,
        title: const Text(
          "SIGN IN TO YOUR ACCOUNT",
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

            //checks if connected 
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
                          child: SizedBox(

                            //email text field
                            child: TextField(
                              controller: _email,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter your email here",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: SizedBox(

                            //password text field
                            child: TextField(
                              controller: _password,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 10, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //login state bloc
                    BlocConsumer<LoginStateBloc, LoginState>(
                        listener: (context, state) {
                      if (state is AppStateInitial) {
                      } else if (state is AppStateLoggedIn) {

                        //shows a dialog to show the user is logged in
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text('Login Successful!'),
                                  content: Text(
                                      'You are logged in as ${state.email}'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyHomePage()));
                                      },
                                      child: const Text('Go to home page'),
                                    ),
                                  ],
                                ));
                      } else if (state is AppStateError) {

                        //shows an error dialog
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(state.error.dialogTitle),
                                  content: Text(state.error.dialogText),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterView()));
                                      },
                                      child: const Text("Sign Up"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ));
                      }
                    }, builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            BlocProvider.of<LoginStateBloc>(context).initFirebase(email, password);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterView()));
                        },
                        child: const Text("Not yet registered? Sign up now!",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                               color: Color.fromRGBO(240, 140, 10, 100)))),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: SizedBox(
                        child: Image.asset(
                          'assets/catimage/c1.png',
                          height: 200,
                        ),
                      ),
                    )
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
