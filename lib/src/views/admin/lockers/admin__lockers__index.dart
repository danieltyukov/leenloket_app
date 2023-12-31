import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminLockersIndex extends StatefulWidget {
  const AdminLockersIndex({super.key});

  static const routeName = '/admin/lockers/index';

  @override
  State<AdminLockersIndex> createState() => _AdminLockersIndexState();
}

class _AdminLockersIndexState extends State<AdminLockersIndex> {
  final ref = FirebaseDatabase.instance.ref('Lockers');

  void _createNewLocker() async {
    final TextEditingController locationController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Locker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (locationController.text.isNotEmpty &&
                  statusController.text.isNotEmpty) {
                ref.push().set({
                  'Location': locationController.text,
                  'Status': statusController.text,
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteLocker(String key) {
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Index Lockers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createNewLocker,
            ),
          ],
        ),
        body: FirebaseAnimatedList(
          padding: const EdgeInsets.all(15),
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            final location = snapshot.child('Location').value.toString();
            final status = snapshot.child('Status').value.toString();
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: ListTile(
                  title: Text(location),
                  subtitle: Text("ID: ${snapshot.key}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(status),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLocker(snapshot.key!),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
