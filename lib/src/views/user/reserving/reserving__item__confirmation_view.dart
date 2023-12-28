import 'package:Leenloket/src/views/user/reservations/user__reservations__single.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/views/user/home/home_view.dart';

class ReservingItemConfirmation extends StatefulWidget {
  final String reservationId;

  const ReservingItemConfirmation({super.key, required this.reservationId});

  static const routeName = '/reserving/confirmation';

  @override
  State<ReservingItemConfirmation> createState() =>
      _ReservingItemConfirmationState();
}

class _ReservingItemConfirmationState extends State<ReservingItemConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Reservation Completed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                height: 20), // Adds some spacing between the column and row
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thanks for using Leenloket',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your action for the first button here
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReservationsSingle(
                            reservationId: widget.reservationId!)));
                  },
                  child: const Text('See reservation'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(HomeView.routeName);
                  },
                  child: const Text('Homescreen'),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Adds some spacing between the two rows
          ],
        ),
      ),
    );
  }
}
