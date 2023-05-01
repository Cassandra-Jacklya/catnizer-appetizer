import 'package:catnizer/auth_views/auth_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginStateBloc extends Cubit<LoginState> {
  LoginStateBloc() : super(AppStateInitial());

  void initFirebase(String email, String password) async{
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      emit(AppStateLoggedIn(email: email, password: password));
    } on FirebaseAuthException catch (e) {
      emit(AppStateError(error: authError(e.code)));
    }
  }

  AuthError authError(String code) {
    return AuthError.from(code);
  }
}

abstract class LoginState {}

class AppStateLoggedIn extends LoginState {

  AppStateLoggedIn({required this.email, required this.password});

  final String email;
  final String password;
}

class AppStateLoggedOut extends LoginState {}

class AppStateInitial extends LoginState {}

class AppStateError extends LoginState {
  AppStateError({required this.error});

  final AuthError error;
}