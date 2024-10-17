import 'package:flutter/material.dart';

import 'package:y_alarm/widgets/infos_fenetre.dart';

class Alarm extends StatelessWidget {
  const Alarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alarme'),
        ),
        body: Expanded(child: GetFenetre()),
        );
  }
}
