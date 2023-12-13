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
  final _itemsRef = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
    reservationsRef = FirebaseDatabase.instance.ref().child('Reservations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'My Reservations',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              'Click on a reservation to view more details',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upcoming Reservations',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: buildList("Reserved")),
            const SizedBox(height: 10),
            const Text(
              'Past Reservations',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(child: buildList("Completed")),
            const SizedBox(height: 20),
            const Text(
              'Cancelled Reservations',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(child: buildList("Cancelled")),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }

  Widget buildList(String status) {
    return FirebaseAnimatedList(
      query: reservationsRef.orderByChild('UserID').equalTo(loggedInUserID),
      itemBuilder: (context, snapshot, animation, index) {
        if (snapshot.value != null) {
          return FutureBuilder<String>(
            future: _fetchItemTitle(snapshot.child('ItemID').value.toString()),
            builder: (context, titleSnapshot) {
              if (titleSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or some loading indicator
              } else if (titleSnapshot.hasError) {
                return Text('Error: ${titleSnapshot.error}');
              } else {
                if (snapshot.child('Status').value.toString() == status) {
                  String itemTitle = titleSnapshot.data ?? "Title";

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReservationsSingle(
                              reservationId: snapshot.key!)));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("Reservation for: $itemTitle"),
                        subtitle: Text(
                            "Pickup: ${snapshot.child('StartDate').value}"),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            },
          );
        } else {
          return const SizedBox(); // Placeholder for an empty item
        }
      },
    );
  }

  Future<String> _fetchItemTitle(String itemID) async {
    DataSnapshot itemSnapshot =
        await FirebaseDatabase.instance.ref().child('Items/$itemID').get();
    return itemSnapshot.child('ItemName').value?.toString() ?? "Title";
  }
}
