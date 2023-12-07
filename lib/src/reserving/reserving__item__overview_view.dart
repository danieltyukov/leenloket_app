import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class ReservingItemOverviewView extends StatefulWidget {
  String itemId;

  ReservingItemOverviewView({super.key, required this.itemId});

  static const routeName = '/reserving/overview';

  DateTime selectedStartDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedEndTime = TimeOfDay.now();

  TextEditingController durationController = TextEditingController();

  @override
  State<ReservingItemOverviewView> createState() =>
      _ReservingItemOverviewViewState();
}

class _ReservingItemOverviewViewState extends State<ReservingItemOverviewView> {
  late DatabaseReference _itemRef;

  @override
  void initState() {
    super.initState();
    // Initialize DatabaseReference for the specific item
    _itemRef = FirebaseDatabase.instance.ref('Items/${widget.itemId}');
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectStartDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: widget.selectedStartDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null && pickedDate != widget.selectedStartDate) {
        setState(() {
          widget.selectedStartDate = pickedDate;
        });
      }
    }

    Future<void> _SelectStartTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: widget.selectedStartTime,
      );

      if (pickedTime != null && pickedTime != widget.selectedStartTime) {
        setState(() {
          widget.selectedStartTime = pickedTime;
        });
      }
    }

    Future<String?> getCurrentUserId() async {
      User? user = FirebaseAuth.instance.currentUser;
      String? uID = user?.uid;

      if (user != null) {
        return uID;
      } else {
        return null; // User is not logged in
      }
    }

    bool areFieldsFilled() {
      return widget.durationController.text.isNotEmpty;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview Reservation'),
      ),
      body: FutureBuilder<DatabaseEvent>(
          future: _fetchItemDetails(),
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Data not available');
            } else {
              DataSnapshot itemSnapshot = snapshot.data!.snapshot;
              // Display details for the specific item
              return Container(
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
                              title: Text(
                                  'Selected Start Date: \n${widget.selectedStartDate.day}/'
                                  '${widget.selectedStartDate.month}/${widget.selectedStartDate.year}'),
                              onTap: () => _selectStartDate(context),
                            ),
                            ListTile(
                              title: Text(
                                  'Selected Start Time: \n${widget.selectedStartTime.format(context)}'),
                              onTap: () => _SelectStartTime(context),
                            ),
                            TextField(
                              controller: widget.durationController,
                              decoration: const InputDecoration(
                                labelText: 'Duration (in days)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DatabaseReference dbRef =
                            FirebaseDatabase.instance.ref();

                        String startDate =
                            "${widget.selectedStartDate.year}-${widget.selectedStartDate.month}-${widget.selectedStartDate.day}T${widget.selectedStartTime.hour}:${widget.selectedStartTime.minute}";

                        DateTime startDateWithAddedDays =
                            widget.selectedStartDate.add(Duration(
                                days:
                                    int.parse(widget.durationController.text)));

                        String endDate =
                            "${startDateWithAddedDays.year}-${startDateWithAddedDays.month}-${startDateWithAddedDays.day}T${widget.selectedStartTime.hour}:${widget.selectedStartTime.minute}";

                        try {
                          String? userId = await getCurrentUserId();

                          dbRef.child("Reservations").push().set({
                            "ItemID": itemSnapshot.child('ItemID').value,
                            "UserID": userId,
                            "StartDate": startDate,
                            "EndDate": endDate,
                            "Status": "Complete",
                            "ReservationID": 101,
                          }).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Reservation added"),
                              ),
                            );
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error"),
                            ),
                          );
                        }
                      },
                      child: const Text("Reserve"),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<DatabaseEvent> _fetchItemDetails() async {
    return await _itemRef.once();
  }
}
