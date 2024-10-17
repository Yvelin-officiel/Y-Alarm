// lib/widgets/group_dialog.dart
import 'package:flutter/material.dart';

Future<String?> showEditGroupDialog(BuildContext context, String currentGroupName) {
  final TextEditingController controller = TextEditingController(text: currentGroupName);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modifier le groupe de réveils'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nom du groupe'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la boîte de dialogue sans rien renvoyer
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final groupName = controller.text;
              if (groupName.isNotEmpty) {
                Navigator.of(context).pop(groupName); // Retourne le nom du groupe modifié
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      );
    },
  );
}
