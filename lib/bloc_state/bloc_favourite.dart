//bloc class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteBloc extends Cubit<FavouriteEvent> {
  FavouriteBloc() : super(FavouriteLoading());

  void alreadyAdded(String? collection, String? data) async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection!);
      DocumentSnapshot<Object?> doc = await collectionRef.doc(data).get();
      bool docExists = doc.exists;
      if (docExists) {
        emit(FavouriteTrue(true));
      }
      else {
        emit(FavouriteFalse(false));
      }
    } on FirebaseException catch(e) {
      emit(FavouriteError());
    }
  }
}

//state classes
abstract class FavouriteEvent {}

class FavouriteFalse extends FavouriteEvent {
  FavouriteFalse(this.added);

  final bool added;
}

class FavouriteTrue extends FavouriteEvent {
  FavouriteTrue(this.added);

  final bool added;
}

class FavouriteLoading extends FavouriteEvent {}

class FavouriteError extends FavouriteEvent {}