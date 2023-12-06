import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminLockersIndex extends StatefulWidget {
  const AdminLockersIndex({Key? key}) : super(key: key);

  static const routeName = '/admin/lockers/index';

  @override
  State<AdminLockersIndex> createState() => _AdminLockersIndex();
}

class _AdminLockersIndex extends State<AdminLockersIndex> {
  final ref = FirebaseDatabase.instance.ref('Lockers');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Index Lockers'),
      ),
      body: FirebaseAnimatedList(
        padding: const EdgeInsets.all(15),
        query: ref,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: ListTile(
                title: Text(snapshot.child('Location').value.toString()),
                subtitle:
                    Text("ID: ${snapshot.child('LockerID').value.toString()}"),
                trailing: Text(snapshot.child('Status').value.toString()),
              ),
            ),
          );
        },
      ));
}
