import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_1d__period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservingItemStep1c extends StatefulWidget {
  final Item item;
  final UserModel.User user;
  final DateTime startDateTime;

  const ReservingItemStep1c(
      {super.key,
      required this.item,
      required this.user,
      required this.startDateTime});

  static const routeName = '/reserving/new/step1c';

  @override
  State<ReservingItemStep1c> createState() => _ReservingItemStep1cState();
}

class _ReservingItemStep1cState extends State<ReservingItemStep1c> {
  late String selectedEndDate;
  late List<String> endDates = [];

  @override
  void initState() {
    super.initState();
    endDates = generateNext7Days(widget.startDateTime);
    selectedEndDate = endDates[0]; // Initialize selectedDay with the first day.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // Change color as needed
              ),
              child: const Center(
                child: Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white, // Change text color as needed
                    fontSize: 24.0, // Change font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Select return date",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Pickup: ${DateFormat('dd MMMM y HH:mm').format(widget.startDateTime)}",
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: endDates.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEndDate = endDates[index];
                      print(selectedEndDate);
                    });
                  },
                  child: ListTile(
                    title: Text(endDates[index]),
                    tileColor: selectedEndDate == endDates[index]
                        ? Colors.blue.withOpacity(0.2)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservingItemStep1d(
                        item: widget.item,
                        user: widget.user,
                        startDateTime: widget.startDateTime,
                        endDate: parseFormattedDay(selectedEndDate)),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ),
        ]),
      ),
    );
  }
}
