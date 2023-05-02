//bloc class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteBloc extends Cubit<FavouriteEvent> {
  FavouriteBloc() : super(FavouriteLoading());

  void alreadyAdded(String? collection, String? data) async {
    try {
      final firebase = FirebaseAuth.instance.currentUser;
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection ?? '');
      DocumentSnapshot<Object?> doc = await collectionRef.doc(data).get();
      bool docExists = doc.exists;
      if (docExists) {
        print("true fav");
        emit(FavouriteTrue(added: true));
      }
      else {
        print("false fav");
        emit(FavouriteFalse(added: false));
      }
    } on FirebaseException catch(e) {
      emit(FavouriteError());
    }
  }
}

//state classes
abstract class FavouriteEvent {}

class FavouriteFalse extends FavouriteEvent {
  FavouriteFalse({required this.added});

  final bool added;
}

class FavouriteTrue extends FavouriteEvent {
  FavouriteTrue({required this.added});

  final bool added;
}

class FavouriteLoading extends FavouriteEvent {}

class FavouriteError extends FavouriteEvent {}