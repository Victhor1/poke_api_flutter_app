import 'package:pokedex/models/ability.dart';

class Abilities {
  List<Ability>? ability;

  Abilities({this.ability});

  factory Abilities.fromJson(Map<String, dynamic> json) => Abilities(
        ability: json['ability'],
      );

  Map<String, dynamic> toJson() => {
        "abiliti": ability,
      };
}
