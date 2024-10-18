// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/alarm_group.dart';
import '../widgets/alarm_group_dialog.dart';
import '../widgets/group_dialog.dart';
import 'group_detail_screen.dart'; // Importer la boîte de dialogue pour ajouter/modifier des groupes

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlarmGroup> alarmGroups = [
    AlarmGroup(id: '1', name: 'Matin', alarms: []),
    AlarmGroup(id: '2', name: 'Sport', alarms: []),
  ];

  void _addNewGroup(String name) {
    final newGroup = AlarmGroup(id: DateTime.now().toString(), name: name, alarms: []);
    setState(() {
      alarmGroups.add(newGroup); // Ajoute le nouveau groupe
    });
  }

  void _editGroup(int index) async {
    final updatedGroupName = await showEditGroupDialog(context, alarmGroups[index].name);
    if (updatedGroupName != null) {
      setState(() {
        alarmGroups[index].name = updatedGroupName; // Met à jour le nom du groupe
      });
    }
  }

  void _deleteGroup(int index) {
    setState(() {
      alarmGroups.removeAt(index); // Supprime le groupe
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes de Réveils'),
      ),
      body: ListView.builder(
        itemCount: alarmGroups.length,
        itemBuilder: (context, index) {
          final group = alarmGroups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('${group.alarms.length} réveils'), // Nombre actualisé ici
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsScreen(alarmGroup: group),
                ),
              ).then((_) {
                setState(() {}); // Mise à jour après retour de l'écran de détails
              });
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editGroup(index), // Modifier le groupe
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Confirmation avant la suppression
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Supprimer le groupe'),
                          content: const Text('Êtes-vous sûr de vouloir supprimer ce groupe ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Annuler
                              },
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteGroup(index); // Supprimer le groupe
                                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                              },
                              child: const Text('Supprimer'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGroupName = await showGroupDialog(context); // Appelle la fonction pour montrer la boîte de dialogue
          if (newGroupName != null) {
            _addNewGroup(newGroupName); // Ajoute un nouveau groupe si le nom est valide
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
