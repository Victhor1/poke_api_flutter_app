import 'package:flutter/material.dart';

class Abilities extends StatelessWidget {
  final List abilities;
  const Abilities({
    Key? key,
    required this.abilities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5.0,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 2.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              abilities[index]['ability']['name'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
