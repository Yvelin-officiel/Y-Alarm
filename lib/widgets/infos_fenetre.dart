import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetFenetre extends StatefulWidget {
  const GetFenetre({super.key});
  @override
  State<GetFenetre> createState() => _GetFenetre();
}

class _GetFenetre extends State<GetFenetre> {
  String text = "";
  final _random = Random();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Action à réaliser lors du clic
            setState(() {
              rootBundle.loadString('assets/fenetre.txt').then((fileContent) {
                final lines = fileContent.split('\n');
                setState(() {
                  if (lines.isNotEmpty) {
                    text = lines[_random.nextInt(lines.length)];
                  } else {
                    text = "Le fichier est vide";
                  }
                });
              }).catchError((error) {
                setState(() {
                  text = "Le fichier n'existe pas";
                });
              });
            });
          },
          child: Text("Générer une astuce"),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
