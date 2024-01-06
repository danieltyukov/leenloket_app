import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_1c__period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'reserving__item__step_2__payment.dart';

class ReservingItemStep1d extends StatefulWidget {
  final Item item;
  final UserModel.User user;
  final DateTime startDateTime;
  final DateTime endDate;

  const ReservingItemStep1d(
      {super.key,
      required this.item,
      required this.user,
      required this.startDateTime,
      required this.endDate});

  static const routeName = '/reserving/new/step1d';

  @override
  State<ReservingItemStep1d> createState() => _ReservingItemStep1dState();
}

class _ReservingItemStep1dState extends State<ReservingItemStep1d> {
  late String selectedTime;
  late List<String> timeList = [];

  @override
  void initState() {
    super.initState();
    timeList = generateTimeList();
    selectedTime = timeList[0]; // Initialize selectedDay with the first day.
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
            "Select return time",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Pickup: ${DateFormat('dd MMMM y HH:mm').format(widget.startDateTime)}",
          ),
          Text(
            "Return: ${DateFormat('dd MMMM y').format(widget.endDate)}",
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = timeList[index];
                      print(selectedTime);
                    });
                  },
                  child: ListTile(
                    title: Text(timeList[index]),
                    tileColor: selectedTime == timeList[index]
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
                    builder: (context) => ReservingItemStep2(
                      item: widget.item,
                      user: widget.user,
                      startDateTime: widget.startDateTime,
                      endDateTime:
                          combineDateAndTime(widget.endDate, selectedTime),
                    ),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ),
        ]),
      ),
    );
  }
}
