import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_1b__period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservingItemStep1 extends StatefulWidget {
  final Item item;
  final UserModel.User user;

  const ReservingItemStep1({super.key, required this.item, required this.user});

  static const routeName = '/reserving/new/step1a';

  @override
  State<ReservingItemStep1> createState() => _ReservingItemStep1State();
}

class _ReservingItemStep1State extends State<ReservingItemStep1> {
  late String selectedDay;
  late List<String> next7Days;

  @override
  void initState() {
    super.initState();
    next7Days = generateNext7Days(DateTime.now());
    selectedDay = next7Days[0]; // Initialize selectedDay with the first day.
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
            "Select pickup date",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: next7Days.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = next7Days[index];
                      print(selectedDay);
                    });
                  },
                  child: ListTile(
                    title: Text(next7Days[index]),
                    tileColor: selectedDay == next7Days[index]
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
                Navigator.pushNamed(context, ReservingItemStep1b.routeName,
                    arguments: {
                      'item': widget.item,
                      'user': widget.user,
                      'startDate': parseFormattedDay(selectedDay),
                    });
              },
              child: const Text("Choose start time"),
            ),
          )
        ]),
      ),
    );
  }
}
