import 'package:flutter/material.dart';

class ReservingItemOverviewView extends StatelessWidget {
  const ReservingItemOverviewView({super.key});

  static const routeName = '/reserving/overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overview Reservation'),
        ),
        body: const Column(
          children: [Text("Overview Reservation")],
        ));
  }
}
