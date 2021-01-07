import 'dart:async';

import 'hero.dart';
import 'mock_heroes.dart';

class HeroService {
  Future<List<Hero>> getAll() async => mockHeroes;
  // See the "Take it slow" appendix
  Future<List<Hero>> getAllSlowly() {
    return Future.delayed(Duration(seconds: 2), getAll);
  }

  get(int id) async => (await getAll()).firstWhere((hero) => hero.id == id);
}
