import 'package:flutter/material.dart';
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/models/pokemon_detail.dart';
import 'package:pokedex/widget/abilities.dart';
import 'package:pokedex/widget/poke_info.dart';
import 'package:pokedex/widget/spinner.dart';
import 'package:pokedex/widget/stats.dart';

class PokemonScreen extends StatefulWidget {
  final String name;
  const PokemonScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<PokemonDetail>? pokemoIndex;

  Future<void> _refresh() async {
    pokemoIndex = PokeApi().fetchDetailPokemon(widget.name);
    setState(() {
      pokemoIndex = pokemoIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    pokemoIndex = PokeApi().fetchDetailPokemon(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toUpperCase()),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<PokemonDetail>(
        future: pokemoIndex,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Spinner();
          } else {
            if (snapshot.hasData) {
              return RefreshIndicator(
                key: refreshIndicatorKey,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: FadeInImage(
                          height: 210.0,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              '${snapshot.data!.sprites!.frontDefault}'),
                          placeholder: const AssetImage('assets/pokeball.png'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.data!.name}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('#${snapshot.data!.id}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          height: 30,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    'Abilities:',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                Abilities(abilities: snapshot.data!.abilities!)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        child: PokeInfo(
                          experience: snapshot.data!.experience!,
                          height: snapshot.data!.height!,
                          weight: snapshot.data!.weight!,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Stats',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Stats(stats: snapshot.data!.stats!),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Error'));
            }
          }
        },
      ),
    );
  }
}
