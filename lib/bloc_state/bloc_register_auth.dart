import 'package:catnizer/auth_views/auth_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpStateBloc extends Cubit<RegisterState> {
  SignUpStateBloc() : super(RegisterStateInitial());

  void signUp(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterStateDone(email: email));
    } on FirebaseAuthException catch (e) {
      emit(RegisterStateError(error: authError(e.code)));
    }
  }
  
  AuthError authError(String code) {
    return AuthError.from(code);
  }
}

abstract class RegisterState {}

class RegisterStateDone extends RegisterState {
  RegisterStateDone({required this.email});

  final String email;
}

class RegisterStateInitial extends RegisterState {}

class RegisterStateError extends RegisterState {
  RegisterStateError({required this.error});

  final AuthError error;
}