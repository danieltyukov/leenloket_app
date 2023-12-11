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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: _fetchItemDetails(widget.reservationId),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('Data not available');
          } else {
            DataSnapshot reservationSnapshot = snapshot.data!.snapshot;

            return const Padding(
              padding: EdgeInsets.all(15),
              child: Column(children: [
                Row(
                  children: [Text("Pickup code: 1234")],
                )
              ]),
            );
          }
        },
      ),
    );
  }

  Future<DatabaseEvent> _fetchItemDetails(String reservationId) async {
    return await _reservationRef.once();
  }
}
