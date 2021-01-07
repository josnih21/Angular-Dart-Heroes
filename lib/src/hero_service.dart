import 'dart:async';
import 'dart:convert';

import 'package:angular_tour_of_heroes/src/exceptions/exceptions_handler.dart';
import 'package:http/http.dart';

import 'hero.dart';

class HeroService {
  static const _heroesUrl = 'api/heroes';
  static const _headers = {'Content-Type': 'application/json'};

  final Client _http;

  HeroService(this._http);

  Future<List<Hero>> getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractHeroesData(response) as List).map((json) => Hero.fromJson(json)).toList();
      return heroes;
    } catch (error) {
      throw ExceptionHandler.handleError(error);
    }
  }

  Future<Hero> getById(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return Hero.fromJson(_extractHeroesData(response));
    } catch (error) {
      throw ExceptionHandler.handleError(error);
    }
  }

  dynamic _extractHeroesData(Response response) => json.decode(response.body)['data'];
  // See the "Take it slow" appendix
  Future<List<Hero>> getAllSlowly() {
    return Future.delayed(Duration(seconds: 2), getAll);
  }

  get(int id) async => (await getAll()).firstWhere((hero) => hero.id == id);

  Future<Hero> update(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(hero));
      return Hero.fromJson(_extractHeroesData(response));
    } catch (error) {
      throw ExceptionHandler.handleError(error);
    }
  }

  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl, headers: _headers, body: json.encode({'name': name}));
      return Hero.fromJson(_extractHeroesData(response));
    } catch (error) {
      throw ExceptionHandler.handleError(error);
    }
  }

  Future<void> delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch (error) {
      throw ExceptionHandler.handleError(error);
    }
  }
}
