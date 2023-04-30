//bloc class
//this is unused for now
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FavouriteBloc extends Cubit<FavouriteEvent> {
  FavouriteBloc() : super(FavouriteInitial());

  void loadFavourites() async {
    
  }
  
}

//state classes
abstract class FavouriteEvent {}

class FavouriteInitial extends FavouriteEvent {}

class FavouriteLoaded extends FavouriteEvent {
  FavouriteLoaded(this.fact);

  final String fact;
}

class FavouriteError extends FavouriteEvent {}