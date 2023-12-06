import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdimCategoriesIndex extends StatefulWidget {
  const AdimCategoriesIndex({Key? key}) : super(key: key);

  static const routeName = '/admin/categories/index';

  @override
  State<AdimCategoriesIndex> createState() => _AdimCategoriesIndex();
}

class _AdimCategoriesIndex extends State<AdimCategoriesIndex> {
  final ref = FirebaseDatabase.instance.ref('Categories');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Index Categories'),
      ),
      body: FirebaseAnimatedList(
        padding: const EdgeInsets.all(15),
        query: ref,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: ListTile(
                title: Text(snapshot.child('CategoryName').value.toString()),
                subtitle: Text(
                    "ID: ${snapshot.child('CategoryID').value.toString()}"),
              ),
            ),
          );
        },
      ));
}
