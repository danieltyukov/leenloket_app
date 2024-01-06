import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/reservation_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/views/user/reserving/reserving__item__confirmation_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservingItemStep2 extends StatefulWidget {
  final Item item;
  final UserModel.User user;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const ReservingItemStep2(
      {super.key,
      required this.item,
      required this.user,
      required this.startDateTime,
      required this.endDateTime});

  static const routeName = '/reserving/new/step2';

  @override
  State<ReservingItemStep2> createState() => _ReservingItemStep2State();
}

class _ReservingItemStep2State extends State<ReservingItemStep2> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = double.parse(widget.item.pricePerDay) *
        widget.endDateTime.difference(widget.startDateTime).inDays;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    '3',
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
              "Payment",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "The price per day is ${widget.item.pricePerDay} euro. We will ask for a deposit, you will get this back when you return the item in good condition.",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              //show start date and enddate
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Reservation details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Item",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.item.itemName,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pickup",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM y   HH:mm')
                              .format(widget.startDateTime),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Return",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM y   HH:mm')
                              .format(widget.endDateTime),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //Calculate price
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price per day",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${widget.item.pricePerDay} euro",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Number of days",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${widget.endDateTime.difference(widget.startDateTime).inDays} day(s)",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "$totalPrice euro",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Reservation newReservation = Reservation(
                    userID: widget.user.id,
                    itemID: widget.item.itemID,
                    startDate: DateFormat('dd MMMM y HH:mm')
                        .format(widget.startDateTime),
                    endDate: DateFormat('dd MMMM y HH:mm')
                        .format(widget.endDateTime),
                    status: "Reserved",
                  );

                  //Deduct credit from user
                  if (await widget.user.hasEnoughCredit(totalPrice)) {
                    widget.user.deductCredit(totalPrice);

                    //Create reservation in database
                    widget.user.createReservation(newReservation);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservingItemConfirmation(
                          reservation: newReservation,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "You don't have enough credit to reserve this item."),
                      ),
                    );
                  }
                },
                child: const Text("Confirm & Pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
