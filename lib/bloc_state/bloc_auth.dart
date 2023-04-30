import 'package:catnizer/auth_views/auth_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppStateBloc extends Cubit<AppState> {
  AppStateBloc() : super(AppStateInitial());

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

abstract class AppState {}

class AppStateLoggedIn extends AppState {

  AppStateLoggedIn({required this.email, required this.password});

  final String email;
  final String password;
}

class AppStateLoggedOut extends AppState {}

class AppStateRegisterView extends AppState {
  AppStateRegisterView({required this.email, required this.password});

  final String email;
  final String password;
}

class AppStateInitial extends AppState {}

class AppStateError extends AppState {
  AppStateError({required this.error});

  final AuthError error;
}