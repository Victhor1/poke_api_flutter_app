import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/constant.dart';
import 'package:pokedex/widget/pokemon_card.dart';
import 'package:pokedex/widget/spinner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List data = [];
  int offset = 10;
  int dataCount = 0;
  int deleteCount = 0;
  bool _loading = true;
  bool _moreData = true;

  Future<void> makeApiRequest() async {
    var response = await http.get(
      Uri.parse(baseUrl + 'pokemon?offset=$offset&limit=10'),
    );
    if (response.statusCode == 200) {
      final dataItems = jsonDecode(response.body);
      setState(() {
        data.addAll(dataItems['results']);
        _loading = _loading ? !_loading : _loading;
        _moreData = false;
        dataCount = data.length;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: '$response'),
      );
    }
  }

  Future<void> _refresh() async {
    data.clear();
    setState(() {
      offset = 10;
      _loading = true;
      dataCount = 0;
      deleteCount = 0;
    });
    makeApiRequest();
  }

  void removeCard(value) {
    if (data.contains(value)) {
      data.remove(value);
      setState(() => dataCount = data.length);
      deleteCount++;
      showTopSnackBar(
        context,
        CustomSnackBar.success(
            message: value['name'] + ' se elimino de la lista.'),
      );
    } else {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
            message: 'El elemento no se encuentra en la lista'),
      );
    }
  }

  Future openDialog(value) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar de la lista'),
        content: Text('¿Estas apunto de elimnar ${value['name']} de la lista?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              removeCard(value);
            },
            child: const Text('Si'),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //retrieveCards();
    if (mounted) {
      makeApiRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pokedex'.toUpperCase()),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              final results = await showSearch(
                context: context,
                delegate: PokemonSearch(),
              );

              //Cierra el buscador y abre otra pantalla
              // if (results != null) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => PokemonScreen(
              //         name: results.toString(),
              //       ),
              //     ),
              //   );
              // }
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: _loading
          ? const Spinner()
          : Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!_moreData &&
                          (scrollInfo.metrics.maxScrollExtent -
                                      scrollInfo.metrics.pixels)
                                  .round() <=
                              200) {
                        setState(
                          () {
                            offset = offset + 10;
                            _moreData = true;
                          },
                        );
                        makeApiRequest();
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      color: Theme.of(context).primaryColor,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            key: ValueKey(data[index]['name']),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                removeCard(data[index]);
                              }),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    openDialog(data[index]);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Eliminar',
                                )
                              ],
                            ),
                            child: PokemonCard(
                              name: data[index]['name'],
                              url: data[index]['url'],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (_moreData) const CircularProgressIndicator()
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.3),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pokemons listados:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    dataCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pokemons eliminados:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    deleteCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PokemonSearch extends SearchDelegate<String> {
  // final pokemons = ['pikachu', 'snorlax'];
  // final recentPokemnons = ['kakuna', 'raichu'];
  //Cuando la data es local

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_activity,
              size: 20,
            ),
            const SizedBox(
              height: 48,
            ),
            Text(query)
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<String>>(
        future: PokeApi.searchPokemon(query),
        builder: (context, snapshot) {
          if (query.isEmpty) return buildNoSuggestions();
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Spinner();
            default:
              if (snapshot.data!.isEmpty) {
                return buildNoSuggestions();
              } else {
                return buildSuggestionsSuccess(snapshot.data!);
              }
          }
        },
      );

  // { Cuando la data es local
  //   final suggestions = query.isEmpty
  //       ? recentPokemnons
  //       : pokemons.where((pokemon) {
  //           final pokemonLower = pokemon.toLowerCase();
  //           final querLower = query.toLowerCase();
  //           return pokemonLower.startsWith(querLower);
  //         }).toList();

  //   return buildSuggestionsSuccess(suggestions);
  // }

  Widget buildNoSuggestions() => const Center(
        child: Text('No results'),
      );

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return PokemonCard(name: suggestion, url: suggestion);
          // return ListTile(
          //   onTap: () {
          //     query = suggestion;

          //     //close(context, suggestion);
          //     //cierra el buscador y abre otra pantalla

          //     //showResults(context); --muestra el resultado en showResults

          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //         builder: (context) => PokemonScreen(name: suggestion)));
          //     //navega a otra pantalla
          //   },
          //   leading: const Icon(Icons.location_city),
          //   title: Text(suggestion),
          // );
        },
      );
}
