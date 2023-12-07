import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserReservationsIndex extends StatefulWidget {
  const UserReservationsIndex({Key? key}) : super(key: key);

  static const routeName = '/user/reservations/index';

  @override
  State<UserReservationsIndex> createState() => _UserReservationsIndex();
}

class _UserReservationsIndex extends State<UserReservationsIndex> {
  late String loggedInUserID;
  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
    ref = FirebaseDatabase.instance.ref().child('Reservations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildList(),
    );
  }

  Widget buildList() {
    return FirebaseAnimatedList(
      padding: const EdgeInsets.all(15),
      query: ref.orderByChild('UserID').equalTo(loggedInUserID),
      itemBuilder: (context, snapshot, animation, index) {
        if (snapshot.value != null) {
          // Extract reservation details

          return GestureDetector(
            onTap: () {
              // Handle tap
            },
            child: Card(
              child: ListTile(
                title: Text(snapshot.child('ReservationID').value.toString()),
                subtitle: Text("UID: ${snapshot.child('UserID').value}"),
                trailing: Text(snapshot.child('Status').value.toString()),
              ),
            ),
          );
        } else {
          return const SizedBox(); // Placeholder for an empty item
        }
      },
    );
  }
}
