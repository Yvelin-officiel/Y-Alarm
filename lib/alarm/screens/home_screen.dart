// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

import 'package:y_alarm/alarm/models/alarm_group.dart';
import 'package:y_alarm/alarm/service/alam_controller.dart';
import 'package:y_alarm/alarm/widgets/alarm_group_dialog.dart';
import 'package:y_alarm/alarm/widgets/group_dialog.dart';
import 'package:y_alarm/alarm/screens/group_detail_screen.dart'; // Importer la boîte de dialogue pour ajouter/modifier des groupes
import 'package:y_alarm/alarm/service/alarm_group_controller.dart'; // Importer le contrôleur de groupe

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlarmGroup> alarmGroups = [];

  void _addNewGroup(String name) async {
    AlarmGroup newGroup = AlarmGroup(name: name);
    newGroup = await AlarmGroupeController.instance.create(newGroup);
    setState(() {});
  }

  void _editGroup(int index) async {
    final updatedGroupName = await showEditGroupDialog(context, alarmGroups[index].name);
    if (updatedGroupName != null) 
    {
      AlarmGroup alarmGroup = alarmGroups[index];
      alarmGroup.name = updatedGroupName;
      AlarmGroupeController.instance.update(alarmGroup);
      setState(() {});
    }
  }

  void _deleteGroup(int index) {
    AlarmGroupeController.instance.delete(alarmGroups[index].id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes de Réveils'),
      ),
      body: FutureBuilder(
        future: AlarmGroupeController.instance.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des groupes'));
          }
          alarmGroups = snapshot.data as List<AlarmGroup>;
          return ListView.builder(
            itemCount: alarmGroups.length,
            itemBuilder: (context, index) {
              final group = alarmGroups[index];
              return FutureBuilder(
                future: AlarmController.instance.getAllByGroupId(group.id!),
                builder: (context, snapshot) {
                  return ListTile(
                    title: Text(group.name),
                    subtitle: Text('${snapshot.data?.length} réveils'), // Nombre actualisé ici
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
              );
            },
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
