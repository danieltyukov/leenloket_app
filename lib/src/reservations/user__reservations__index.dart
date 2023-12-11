import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:leenloket_app/src/reservations/user__reservations__single.dart';

class UserReservationsIndex extends StatefulWidget {
  const UserReservationsIndex({Key? key}) : super(key: key);

  static const routeName = '/user/reservations/index';

  @override
  State<UserReservationsIndex> createState() => _UserReservationsIndex();
}

class _UserReservationsIndex extends State<UserReservationsIndex> {
  late String loggedInUserID;
  late DatabaseReference reservationsRef;
  late DatabaseReference itemsRef;

  @override
  void initState() {
    super.initState();
    loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
    reservationsRef = FirebaseDatabase.instance.ref().child('Reservations');
    itemsRef = FirebaseDatabase.instance.ref().child('Items');
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
      query: reservationsRef.orderByChild('UserID').equalTo(loggedInUserID),
      itemBuilder: (context, snapshot, animation, index) {
        if (snapshot.value != null) {
          // Extract reservation details

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ReservationsSingle(reservationId: snapshot.key!)));
            },
            child: Card(
              child: ListTile(
                title: Text("Title"),
                subtitle: Text("Pickup: ${snapshot.child('StartDate').value}"),
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
