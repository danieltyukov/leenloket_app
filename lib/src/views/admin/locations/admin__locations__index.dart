import 'package:Leenloket/src/views/admin/users/admin__users__single.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminLocationsIndex extends StatefulWidget {
  const AdminLocationsIndex({super.key});

  static const routeName = '/admin/locations/index';

  @override
  State<AdminLocationsIndex> createState() => _AdminLocationsIndexState();
}

class _AdminLocationsIndexState extends State<AdminLocationsIndex> {
  final ref = FirebaseDatabase.instance.ref('Locations');

  void _createNewLocation() async {
    final TextEditingController locationNameController =
        TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Location'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: locationNameController,
                decoration: const InputDecoration(labelText: 'Location Name'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (locationNameController.text.isNotEmpty &&
                  latitudeController.text.isNotEmpty &&
                  longitudeController.text.isNotEmpty) {
                ref.push().set({
                  'LocationName': locationNameController.text,
                  'Lat': latitudeController.text,
                  'Long': longitudeController.text,
                });
              }
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Index Locations'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createNewLocation,
            ),
          ],
        ),
        body: FirebaseAnimatedList(
          padding: const EdgeInsets.all(15),
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            final userID = snapshot.key;
            final name = snapshot.child('LocationName').value.toString();
            final lat = snapshot.child('Lat').value.toString();
            final long = snapshot.child('Long').value.toString();

            return GestureDetector(
              onTap: () {
                // Implement onTap functionality if required
              },
              child: Card(
                child: ListTile(
                  title: Text('$name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$lat $long"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AdminUserSingle(userID: snapshot.key!)));
                  },
                ),
              ),
            );
          },
        ),
      );
}
