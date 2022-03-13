import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/constant.dart';
import 'package:pokedex/models/pokemon_detail.dart';

class PokeApi {
  Future<PokemonDetail> fetchDetailPokemon(String name) async {
    final response = await http.get(Uri.parse(baseUrl + 'pokemon/$name'));
    var data = PokemonDetail.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('error');
    }
  }

  static Future<List<String>> searchPokemon(String query) async {
    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse(baseUrl + 'pokemon/$query'));
      if (response.statusCode == 200) {
        final pokemon = jsonDecode(response.body);
        final name = pokemon['name'];
        return [name];
      } else {
        return [];
      }
    }

    return [];
  }
}
