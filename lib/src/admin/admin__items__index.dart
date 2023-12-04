import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminIndexItems extends StatefulWidget {
  const AdminIndexItems({Key? key}) : super(key: key);

  static const routeName = '/admin/items/index';

  @override
  State<AdminIndexItems> createState() => _AdminIndexItems();
}

class _AdminIndexItems extends State<AdminIndexItems> {
  final ref = FirebaseDatabase.instance.ref('Items');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Index items'),
      ),
      body: FirebaseAnimatedList(
        padding: const EdgeInsets.all(15),
        query: ref,
        itemBuilder: (context, snapshot, animation, index) {
          return Card(
            child: ListTile(
              title: Text(snapshot.child('Description').value.toString()),
              subtitle: Text("ID: ${snapshot.child('ItemID').value}"),
            ),
          );
        },
      ));

  Future<DataSnapshot> readItems() =>
      FirebaseDatabase.instance.ref('Items').get();
}
