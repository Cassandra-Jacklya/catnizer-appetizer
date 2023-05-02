//bloc class
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPageBloc extends Cubit<MainPageEvent> {
  MainPageBloc() : super(MainPageInitial());

  void getMainStuff() async {
    var response = await http.get(Uri.parse('https://catfact.ninja/fact'));
    const String persianUrl =
        'https://api.thecatapi.com/v1/breeds/search?q=persian';
    const String maincoonUrl =
        'https://api.thecatapi.com/v1/breeds/search?q=maine%20coon';
    const String ragdollUrl =
        'https://api.thecatapi.com/v1/breeds/search?q=ragdoll';
    const String abyUrl =
        'https://api.thecatapi.com/v1/breeds/search?q=abyssinian';
        
    final headers = {'x-api-key': 'live_PIIQWS3doyRZjU7nu9lmcyUq4PpSQNFMFZ6kg7Q2Ofi1MhxsUs48TvyoubQI6SWk'};

    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        //persian  
        final persianResponse = await http.get(Uri.parse(persianUrl), headers: headers);
        final persianData = jsonDecode(persianResponse.body);
        String persianDescription = persianData[0]['description'];

        //maincoon
        final maincoonResponse = await http.get(Uri.parse(maincoonUrl), headers: headers);
        final maincoonData = jsonDecode(maincoonResponse.body);
        String maincoonDescription = maincoonData[0]['description'];

        //ragdoll
        final ragdollResponse = await http.get(Uri.parse(ragdollUrl), headers: headers);
        final ragdollData = jsonDecode(ragdollResponse.body);
        String ragdollDescription = ragdollData[0]['description'];

        //aby
        final abyResponse = await http.get(Uri.parse(abyUrl), headers: headers);
        final abyData = jsonDecode(abyResponse.body);
        String abyDescription = abyData[0]['description'];

        String fact = jsonResponse['fact'];

        emit(MainPageLoaded(fact: fact, persian: persianDescription, maincoon: maincoonDescription, ragdoll: ragdollDescription, aby: abyDescription));
      } else {
        emit(MainPageError());
      }
    } on HttpException catch(e) {
      emit(MainPageError());
    }
    
  }
}

//state classes
abstract class MainPageEvent {}

class MainPageInitial extends MainPageEvent {}

class MainPageLoaded extends MainPageEvent {
  MainPageLoaded({required this.fact, required this.persian, required this.maincoon, required this.ragdoll, required this.aby});

  final String fact;
  final String persian;
  final String maincoon;
  final String ragdoll;
  final String aby;
}

class MainPageError extends MainPageEvent {}