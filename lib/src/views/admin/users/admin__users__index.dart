import 'package:Leenloket/src/views/admin/users/admin__users__single.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminUsersIndex extends StatefulWidget {
  const AdminUsersIndex({super.key});

  static const routeName = '/admin/users/index';

  @override
  State<AdminUsersIndex> createState() => _AdminUsersIndexState();
}

class _AdminUsersIndexState extends State<AdminUsersIndex> {
  final ref = FirebaseDatabase.instance.ref('Users');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Index Users'),
        ),
        body: FirebaseAnimatedList(
          padding: const EdgeInsets.all(15),
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            final userID = snapshot.key;
            final name = snapshot.child('Name').value.toString();

            return GestureDetector(
              onTap: () {
                // Implement onTap functionality if required
              },
              child: Card(
                child: ListTile(
                  title: Text('User $name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User ID: $userID"),
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
