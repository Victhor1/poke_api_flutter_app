import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/constant.dart';
import 'package:pokedex/screens/pokemon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PokemonCard extends StatefulWidget {
  final String name;
  final String url;

  const PokemonCard({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  String picture = '';
  bool _loading = true;

  Future<void> getPicture() async {
    var response = await http.get(
      Uri.parse(baseUrl + 'pokemon/${widget.name}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          picture = data['sprites']['front_default'];
          _loading = _loading ? !_loading : _loading;
        });
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
            message: 'No se pudo obtener la imagen de ${widget.name}'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPicture();
  }

  @override
  void dispose() {
    super.dispose();
    getPicture();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      title: Text(widget.name.toUpperCase()),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PokemonScreen(
              name: widget.name,
            ),
          ),
        );
      },
      onLongPress: () {
        showTopSnackBar(
          context,
          CustomSnackBar.info(message: widget.name.toUpperCase()),
        );
      },
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 64,
          maxHeight: 64,
        ),
        child: _loading
            ? Image.asset(
                'assets/pokeball.png',
                fit: BoxFit.cover,
              )
            : FadeInImage(
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/pokeball.png'),
                image: NetworkImage(picture),
              ),
      ),
    );
  }
}
