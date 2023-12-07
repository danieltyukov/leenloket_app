import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:leenloket_app/src/admin/admin__items__create.dart';
import 'package:leenloket_app/src/admin/admin__items__single.dart';

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
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AdminItemSingleView(itemId: snapshot.key!)));
            },
            child: Card(
              child: ListTile(
                title: Text(snapshot.child('Description').value.toString()),
                subtitle: Text("ID: ${snapshot.child('ItemID').value}"),
                trailing: Text(snapshot.child('Status').value.toString()),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminItemCreate()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add), // Customize the color as needed
      ));
}
