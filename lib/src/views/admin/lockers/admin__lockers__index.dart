import 'package:Leenloket/src/models/locker_model.dart';
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
  final locationRef = FirebaseDatabase.instance.ref('Locations');

  void _createNewLocker() async {
    String? selectedLocationID;
    final TextEditingController statusController = TextEditingController();

    final locationSnapshot = await locationRef.get();

    List<DropdownMenuItem<String>> locationItems =
        locationSnapshot.children.map((e) {
      return DropdownMenuItem<String>(
        value: e.key,
        child: Text(e.child('LocationName').value.toString()),
      );
    }).toList();

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Locker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Locker'),
              items: locationItems,
              onChanged: (String? value) {
                selectedLocationID = value;
              },
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
              if (selectedLocationID != null &&
                  statusController.text.isNotEmpty) {
                ref.push().set({
                  'Location': selectedLocationID,
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

            Locker currentLocker =
                Locker(id: snapshot.key!, locationID: location, status: status);

            return GestureDetector(
              onTap: () {},
              child: Card(
                child: FutureBuilder(
                  future: currentLocker.fetchLocation(),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        subtitle: Text("${snapshot.data}"),
                        title: Text("ID: ${currentLocker.id}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(status),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLocker(snapshot.data!),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
          },
        ),
      );
}
