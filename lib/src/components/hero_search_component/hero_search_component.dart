import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_tour_of_heroes/src/hero_search_service.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../hero.dart';

@Component(
  selector: 'hero-search',
  directives: [coreDirectives],
  providers: [ClassProvider(HeroSearchService)],
  pipes: [commonPipes],
  templateUrl: 'hero_search_component.html',
  styleUrls: ['hero_search_component.css'],
)
class HeroSearchComponent implements OnInit {
  final HeroSearchService _heroSearchService;
  final Router _router;

  HeroSearchComponent(this._heroSearchService, this._router);

  Stream<List<Hero>> heroes;
  StreamController<String> _searchTerms = StreamController<String>.broadcast();

  void search(String term) => _searchTerms.add(term);

  @override
  void ngOnInit() {
    heroes = _searchTerms.stream.transform(debounce(Duration(milliseconds: 300))).distinct().transform(switchMap(
        (term) =>
            term.isEmpty ? Stream<List<Hero>>.fromIterable([<Hero>[]]) : _heroSearchService.search(term).asStream()));
  }

  String _heroUrl(int id) => RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail(Hero hero) => _router.navigate(_heroUrl(hero.id));
}
