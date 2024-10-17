import 'package:flutter/material.dart';

import 'package:y_alarm/widgets/get_fenetre.dart';

class Alarm extends StatelessWidget {
  const Alarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alarme'),
        ),
        body: Column(children: [
          ElevatedButton(
            child: Text('Bienvenue sur la page alarme'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: GetFenetre()),
        ]));
  }
}
