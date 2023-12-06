import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class ReservingItemOverviewView extends StatefulWidget {
  const ReservingItemOverviewView({super.key});

  static const routeName = '/reserving/overview';

  @override
  State<ReservingItemOverviewView> createState() =>
      _ReservingItemOverviewViewState();
}

class _ReservingItemOverviewViewState extends State<ReservingItemOverviewView> {
  @override
  Widget build(BuildContext context) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Overview Reservation'),
        ),
        body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                    child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                      "To complete your reservation, please fill in the form."),
                )),
                const SizedBox(height: 30),
                Card(
                    child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(children: [
                    const Text(
                      "Complete your reservation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DateTimeField(
                        decoration:
                            const InputDecoration(hintText: "Startdate/time"),
                        selectedDate: startDate,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            startDate = value;
                          });
                        }),
                    const SizedBox(height: 15),
                    DateTimeField(
                        decoration: const InputDecoration(hintText: 'test'),
                        selectedDate: endDate,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            endDate = DateTime(value.year, value.day,
                                value.hour, value.minute);
                          });
                        }),
                  ]),
                )),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Reserve"))
              ],
            )));
  }
}
