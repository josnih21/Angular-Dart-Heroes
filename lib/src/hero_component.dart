import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-hero',
  templateUrl: 'hero_component.html',
  styleUrls: ['hero_component.css'],
  directives: [coreDirectives, formDirectives],
)
class HeroComponent implements OnActivate {
  final HeroService _heroService;
  final Location _location;

  HeroComponent(this._heroService, this._location);
  Hero hero;

  @override
  void onActivate(RouterState previous, RouterState current) async {
    final id = getId(current.parameters);
    if (id != null) {
      hero = await (_heroService.get(id));
    }
  }

  void goBack() => _location.back();
}
