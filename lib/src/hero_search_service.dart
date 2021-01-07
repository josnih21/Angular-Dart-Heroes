import 'dart:async';
import 'dart:convert';

import 'package:angular_tour_of_heroes/src/exceptions/exceptions_handler.dart';
import 'package:http/http.dart';

import 'hero.dart';

class HeroSearchService {
  final Client _http;

  HeroSearchService(this._http);

  Future<List<Hero>> search(String term) async {
    try {
      final response = await _http.get('app/heroes/?name=$term');
      return (_extractData(response) as List).map((json) => Hero.fromJson(json)).toList();
    } catch (error) {
      ExceptionHandler.handleError(error);
    }
  }

  dynamic _extractData(Response response) => json.decode(response.body)['data'];
}
