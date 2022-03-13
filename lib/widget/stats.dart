import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final List stats;
  const Stats({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stats[index]['stat']['name'],
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LinearProgressIndicator(
                semanticsLabel: 'valor',
                value: (stats[index]['base_stat'] * 0.01),
                backgroundColor: Colors.blue,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )),
            Text(
              stats[index]['base_stat'].toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
