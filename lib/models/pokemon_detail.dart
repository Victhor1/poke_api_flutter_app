import 'dart:convert';
import 'package:pokedex/models/sprites.dart';

class PokemonDetail {
  String? name;
  int? id;
  int? weight;
  Sprites? sprites;
  List? abilities;
  int? experience;
  int? height;
  List? stats;

  PokemonDetail({
    this.name,
    this.weight,
    this.id,
    this.sprites,
    this.abilities,
    this.experience,
    this.height,
    this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) => PokemonDetail(
        name: json["name"],
        id: json["id"],
        weight: json["weight"],
        sprites: Sprites.fromJson(
          json['sprites'],
        ),
        abilities: json['abilities'],
        experience: json['base_experience'],
        height: json['height'],
        stats: json['stats'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "weight": weight,
        "sprites": sprites,
        "abilities": abilities,
        "experience": experience,
        "height": height,
        "stats": stats,
      };
}

PokemonDetail pokemonDetailFromJson(String str) =>
    PokemonDetail.fromJson(json.decode(str));

String pokemonDetailToJson(PokemonDetail data) => json.encode(data.toJson());
