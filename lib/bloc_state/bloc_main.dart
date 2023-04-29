//bloc class
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MainPageBloc extends Cubit<MainPageEvent> {
  MainPageBloc() : super(MainPageInitial());

  void getCatFact() async {
    var response = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      String fact = jsonResponse['fact'];
      emit(MainPageLoaded(fact));
    } else {
      emit(MainPageError());
    }
  }
}

//state classes
abstract class MainPageEvent {}

class MainPageInitial extends MainPageEvent {}

class MainPageLoaded extends MainPageEvent {
  MainPageLoaded(this.fact);

  final String fact;
}

class MainPageError extends MainPageEvent {}