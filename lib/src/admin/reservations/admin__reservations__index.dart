import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminReservationsIndex extends StatefulWidget {
  const AdminReservationsIndex({Key? key}) : super(key: key);

  static const routeName = '/admin/reservations/index';

  @override
  State<AdminReservationsIndex> createState() => _AdminReservationsIndex();
}

class _AdminReservationsIndex extends State<AdminReservationsIndex> {
  final ref = FirebaseDatabase.instance.ref('Reservations');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Index Reservations'),
      ),
      body: FirebaseAnimatedList(
        padding: const EdgeInsets.all(15),
        query: ref,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: ListTile(
                title: Text(snapshot.child('ReservationID').value.toString()),
                subtitle:
                    Text("UID: ${snapshot.child('UserID').value.toString()}"),
                trailing: Text(snapshot.child('Status').value.toString()),
              ),
            ),
          );
        },
      ));
}
