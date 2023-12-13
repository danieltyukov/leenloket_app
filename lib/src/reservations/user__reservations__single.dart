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
  final _codesRef = FirebaseDatabase.instance.ref('Codes');
  final _itemsRef = FirebaseDatabase.instance.ref('Items');
  String _code = '';
  String _itemName = '';
  String _itemDescription = '';

  @override
  void initState() {
    super.initState();
    _reservationRef =
        FirebaseDatabase.instance.ref('Reservations/${widget.reservationId}');
    fetchCode(widget.reservationId);
    fetchItem(widget.reservationId);
  }

  Future<DatabaseEvent> fetchReservation(String reservationId) async {
    return await _reservationRef.once();
  }

  Future<void> fetchCode(String reservationId) async {
    DataSnapshot snapshot = await _codesRef.get();
    String code = '';

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['ReservationID'] == reservationId) {
          code = value['PINCode'];
        }
      });
    }

    setState(() {
      _code = code;
    });
  }

  Future<void> fetchItem(String reservationId) async {
    final reservation =
        FirebaseDatabase.instance.ref('Reservations/${widget.reservationId}');

    DataSnapshot reservationSnapshot = await reservation.get();
    DataSnapshot itemsSnapshot = await _itemsRef.get();

    String itemId = reservationSnapshot.child('ItemID').value.toString();

    String itemName = '';

    if (itemsSnapshot.exists) {
      Map<dynamic, dynamic> values = itemsSnapshot.value as Map;
      values.forEach((key, value) {
        if (key == itemId) {
          itemName = value['ItemName'];
        }
      });
    }

    setState(() {
      _itemName = itemName;
    });
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
                Row(children: [
                  Text(
                      "Return date: ${reservationSnapshot.child("EndDate").value.toString()}")
                ]),
                Row(children: [
                  Text(
                      "Status: ${reservationSnapshot.child("Status").value.toString()}")
                ]),
                Row(children: [Text("Code: $_code")]),
                Row(children: [Text("Item: $_itemName")]),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _reservationRef.update({
                            'Status': 'Cancelled',
                          });
                        },
                        child: const Text('Cancel Reservation'))
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
