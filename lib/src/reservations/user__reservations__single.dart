import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class ReservationsSingle extends StatefulWidget {
  final String reservationId;

  const ReservationsSingle({super.key, required this.reservationId});

  static const routeName = '/reservations/single';
  @override
  State<ReservationsSingle> createState() => _ReservationsSingle();
}

class _ReservationsSingle extends State<ReservationsSingle> {
  late DatabaseReference _reservationRef;
  late DatabaseReference _codesRef;

  @override
  void initState() {
    super.initState();
    // Initialize DatabaseReference for the specific item
    _reservationRef =
        FirebaseDatabase.instance.ref('Reservations/${widget.reservationId}');
    _codesRef = FirebaseDatabase.instance.ref('Codes');
  }

  Future<DatabaseEvent> fetchReservation(String reservationId) async {
    return await _reservationRef.once();
  }

  Future<DatabaseEvent> fetchCodes(String reservationId) async {
    return await _codesRef
        .orderByChild('ReservationID')
        .equalTo(reservationId)
        .once();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: FutureBuilder(
        future: fetchReservation(widget.reservationId),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('Data not available');
          } else {
            DataSnapshot reservationSnapshot = snapshot.data!.snapshot;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                        "Pickup date: ${reservationSnapshot.child("StartDate").value.toString()}")
                  ],
                ),
                Row(
                  children: [
                    FutureBuilder(
                      future: fetchCodes(widget.reservationId),
                      builder: (context, codeSnapshot) {
                        if (codeSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (codeSnapshot.hasError) {
                          return Text('Error: ${codeSnapshot.error}');
                        } else {
                          // Access your data using reservationSnapshot.data and codeSnapshot.data

                          return const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Code: 1234'),
                            ],
                          );
                        }
                      },
                    )
                  ],
                )
              ]),
            );
          }
        },
      ),
    );
  }
}
