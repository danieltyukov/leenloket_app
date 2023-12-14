import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:Leenloket/src/reserving/reserving__item__confirmation_view.dart';

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
  int currentStep = 0;
  int selectedNumber = 1;

  @override
  void initState() {
    super.initState();
    // Initialize DatabaseReference for the specific item
    _itemRef = FirebaseDatabase.instance.ref('Items/${widget.itemId}');
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
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

  bool areFieldsFilled() {
    return widget.durationController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
              return Stepper(
                type: StepperType.vertical,
                steps: getSteps(itemSnapshot, currentStep, user!),
                currentStep: currentStep,
                onStepContinue: () {
                  if (currentStep <
                      getSteps(itemSnapshot, currentStep, user).length - 1) {
                    setState(() {
                      currentStep++;
                      getSteps(itemSnapshot, currentStep, user);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Complete"),
                      ),
                    );
                  }
                },
                onStepCancel: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep--;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cancelled"),
                      ),
                    );
                  }
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails controlsDetails) {
                  return Row(
                    children: [
                      if (currentStep == 0)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: controlsDetails.onStepContinue,
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      if (currentStep == 1)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: controlsDetails.onStepContinue,
                              child: const Text('Next'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: controlsDetails.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      if (currentStep == 2)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: controlsDetails.onStepContinue,
                              child: const Text('Next'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: controlsDetails.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      if (currentStep == 3)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                DatabaseReference dbRefReservations =
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child("Reservations");

                                DatabaseReference dbRefCodes = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child("Codes");

                                String startDate =
                                    "${widget.selectedStartDate.year}-${widget.selectedStartDate.month}-${widget.selectedStartDate.day} ${widget.selectedStartTime.hour}:${widget.selectedStartTime.minute}";

                                DateTime startDateWithAddedDays = widget
                                    .selectedStartDate
                                    .add(Duration(days: selectedNumber));

                                String endDate =
                                    "${startDateWithAddedDays.year}-${startDateWithAddedDays.month}-${startDateWithAddedDays.day} ${widget.selectedStartTime.hour}:${widget.selectedStartTime.minute}";

                                try {
                                  String? userId = user.uid;

                                  DatabaseReference newReservationRef =
                                      dbRefReservations.push();

                                  int reservationCode = createReservationCode();

                                  newReservationRef.set({
                                    "ItemID": itemSnapshot.key,
                                    "UserID": userId,
                                    "StartDate": startDate,
                                    "EndDate": endDate,
                                    "Status": "Reserved",
                                  });

                                  dbRefCodes.push().set({
                                    "Code": "QRCODEHERE",
                                    "PINCode": "$reservationCode",
                                    "ReservationID": newReservationRef.key,
                                  }).then((_) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReservingItemConfirmation(
                                                    reservationId:
                                                        newReservationRef
                                                            .key!)));
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
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: controlsDetails.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  int createReservationCode() {
    Random random = Random();
    int randomNumber = random.nextInt(9999);

    FirebaseDatabase.instance.ref('Codes/$randomNumber').get().then((value) {
      if (value.exists) {
        createReservationCode();
      }
    });

    return randomNumber;
  }

  Future<DatabaseEvent> _fetchItemDetails() async {
    return await _itemRef.once();
  }

  List<Step> getSteps(DataSnapshot itemSnapshot, int currentStep, User user) {
    return [
      Step(
          title: const Text("Account"),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          content: Column(
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
              Card(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text(
                          "Account Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                            "The following details will be used to rent the item."),
                        const SizedBox(height: 30),
                        Text("Email: ${user.email!}"),
                      ],
                    )),
              )
            ],
          )),
      Step(
          title: const Text("Period"),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Select a date and time to rent the item.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('${widget.selectedStartDate.day}/'
                            '${widget.selectedStartDate.month}/${widget.selectedStartDate.year}'),
                        onTap: () => _selectStartDate(context),
                      ),
                      ListTile(
                        title: Text(widget.selectedStartTime.format(context)),
                        onTap: () => _SelectStartTime(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Select the duration of the rental.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedNumber,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedNumber = newValue!;
                          });
                        },
                        items: List.generate(
                          7,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1} days'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
      Step(
          title: const Text("Payment"),
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          content: const Text("content"),
          isActive: currentStep >= 2),
      Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          title: const Text("Confirmation"),
          content: Column(
            children: [
              const Text(
                "Please confirm your reservation details.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Item:"),
                          const SizedBox(width: 10),
                          Text("${itemSnapshot.child('ItemName').value}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Start Date:"),
                          const SizedBox(width: 10),
                          Text(
                              "${widget.selectedStartDate.day}/${widget.selectedStartDate.month}/${widget.selectedStartDate.year}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("End Date:"),
                          const SizedBox(width: 10),
                          Text(
                              "${widget.selectedEndDate.day}/${widget.selectedEndDate.month}/${widget.selectedEndDate.year}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Duration:"),
                          const SizedBox(width: 10),
                          Text("$selectedNumber days"),
                        ],
                      ),
                    ])),
              ),
              const SizedBox(height: 30),
            ],
          ),
          isActive: currentStep >= 3),
    ];
  }
}
