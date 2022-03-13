import 'dart:convert';

import 'package:pokedex/constant.dart';
import 'package:pokedex/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/card.dart';

Future<ApiResponse> getCards() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(Uri.parse(allPokemons), headers: {
      'Accept': 'application/json',
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['results']
            .map((c) => Card.fromJson(c))
            .toList();
        apiResponse.data as List<dynamic>;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
