import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminItemSingleView extends StatefulWidget {
  const AdminItemSingleView({Key? key}) : super(key: key);

  static const routeName = '/admin/items/single';

  @override
  State<AdminItemSingleView> createState() => _AdminItemSingleViewState();
}

class _AdminItemSingleViewState extends State<AdminItemSingleView> {
  final ref = FirebaseDatabase.instance.ref('Items');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Single'),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        itemBuilder: (context, snapshot, animation, index) {
          return Card(
            child: ListTile(
              title: Text(snapshot.child('Status').value.toString()),
            ),
          );
        },
      ));
}
