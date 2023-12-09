import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminReservationsIndex extends StatefulWidget {
  const AdminReservationsIndex({Key? key}) : super(key: key);

  static const routeName = '/admin/reservations/index';

  @override
  State<AdminReservationsIndex> createState() => _AdminReservationsIndexState();
}

class _AdminReservationsIndexState extends State<AdminReservationsIndex> {
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
            final reservationId = snapshot.key;
            final userId = snapshot.child('UserID').value.toString();
            final itemId = snapshot.child('ItemID').value.toString();
            final startDate = snapshot.child('StartDate').value.toString();
            final endDate = snapshot.child('EndDate').value.toString();
            final status = snapshot.child('Status').value.toString();

            return GestureDetector(
              onTap: () {
                // Implement onTap functionality if required
              },
              child: Card(
                child: ListTile(
                  title: Text('Reservation #$reservationId'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User ID: $userId"),
                      Text("Item ID: $itemId"),
                      Text("Start Date: $startDate"),
                      Text("End Date: $endDate"),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(status),
                    backgroundColor:
                        status == 'Reserved' ? Colors.blue : Colors.green,
                  ),
                ),
              ),
            );
          },
        ),
      );
}
