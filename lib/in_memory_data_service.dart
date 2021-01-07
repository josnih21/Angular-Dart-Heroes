import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'src/hero.dart';

class InMemoryDataService extends MockClient {
  static final _initialHeroes = [
    {'id': 11, 'name': 'SpiderCerdo'},
    {'id': 12, 'name': 'Freeze Corleone'},
    {'id': 13, 'name': 'Cabesa Buke'},
    {'id': 14, 'name': 'El cabesita'},
    {'id': 15, 'name': 'Illo Uan'},
    {'id': 16, 'name': 'Maikel of the Street'},
    {'id': 17, 'name': 'Elba Silon'},
    {'id': 18, 'name': 'Paco Munista'},
    {'id': 19, 'name': 'Killo Cabesa'},
    {'id': 20, 'name': 'Capricornio TV'}
  ];
  static List<Hero> _heroesDb;
  static int _nextId;
  static Future<Response> _handler(Request request) async {
    if (_heroesDb == null) resetDb();
    var data;
    switch (request.method) {
      case 'GET':
        final id = int.tryParse(request.url.pathSegments.last);
        if (id != null) {
          data = _heroesDb.firstWhere((hero) => hero.id == id); // throws if no match
        } else {
          String prefix = request.url.queryParameters['name'] ?? '';
          final regExp = RegExp(prefix, caseSensitive: false);
          data = _heroesDb.where((hero) => hero.name.contains(regExp)).toList();
        }
        break;
      case 'POST':
        var name = json.decode(request.body)['name'];
        var newHero = Hero(_nextId++, name);
        _heroesDb.add(newHero);
        data = newHero;
        break;
      case 'PUT':
        var heroChanges = Hero.fromJson(json.decode(request.body));
        var targetHero = _heroesDb.firstWhere((h) => h.id == heroChanges.id);
        targetHero.name = heroChanges.name;
        data = targetHero;
        break;
      case 'DELETE':
        var id = int.parse(request.url.pathSegments.last);
        _heroesDb.removeWhere((hero) => hero.id == id);
        // No data, so leave it as null.
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return Response(json.encode({'data': data}), 200, headers: {'content-type': 'application/json'});
  }

  static resetDb() {
    _heroesDb = _initialHeroes.map((json) => Hero.fromJson(json)).toList();
    _nextId = _heroesDb.map((hero) => hero.id).fold(0, max) + 1;
  }

  static String lookUpName(int id) => _heroesDb.firstWhere((hero) => hero.id == id, orElse: null)?.name;
  InMemoryDataService() : super(_handler);
}
