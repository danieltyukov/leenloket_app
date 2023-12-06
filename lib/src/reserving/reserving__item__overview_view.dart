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
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
        });
      }
    }

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
                  "To complete your reservation, please fill in the form.",
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      "Complete your reservation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      title: Text('Selected Date: ${selectedDate.toLocal()}'),
                      onTap: () => _selectDate(context),
                    ),
                    ListTile(
                      title: Text(
                          'Selected Time: ${selectedTime.format(context)}'),
                      onTap: () => _selectTime(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Reserve"),
            ),
          ],
        ),
      ),
    );
  }
}
