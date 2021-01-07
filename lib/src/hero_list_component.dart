import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-heroes',
  pipes: [commonPipes],
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  directives: [coreDirectives],
  providers: [ClassProvider(HeroService)],
)
class HeroListComponent implements OnInit {
  final HeroService _heroService;
  List<Hero> heroes;
  Hero selected;

  HeroListComponent(this._heroService);

  Future<NavigationResult> gotoDetail() => null;

  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }

  Future<void> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return null;
    heroes.add(await _heroService.create(name));
    selected = null;
  }

  Future<void> delete(Hero hero) async {
    await _heroService.delete(hero.id);
    heroes.remove(hero);
    if (selected == hero) selected == null;
  }

  void ngOnInit() => _getHeroes();

  void onSelect(Hero hero) => selected = hero;
}
