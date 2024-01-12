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

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.15),
                  height: size.height * 0.8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Row(children: [
                            Text('Reservation',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ]),
                          const Text('Step 2 of 2: Payment',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 30),
                          const Text('Reservation details ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Text('Start date: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  Text(
                                      "${widget.startDateTime.day}/${widget.startDateTime.month}/${widget.startDateTime.year} ${widget.startDateTime.hour}:${widget.startDateTime.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('End date: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  Text(
                                      "${widget.endDateTime.day}/${widget.endDateTime.month}/${widget.endDateTime.year} ${widget.endDateTime.hour}:${widget.endDateTime.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ],
                              ),
                              //Pickup location
                              Row(
                                children: [
                                  const Text('Pickup location: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  FutureBuilder(
                                      future: widget.item.getLocationName(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data!,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black));
                                        } else {
                                          return const Text("Loading...",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black));
                                        }
                                      }),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text('Credit ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Current credit: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              FutureBuilder(
                                  future: widget.user.fetchDoubleCredit(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text("€${snapshot.data}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black));
                                    } else {
                                      return const Text("Loading...",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black));
                                    }
                                  }),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Total price: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text("€${totalPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            ],
                          ),
                          //new credit
                          Row(
                            children: [
                              const Text('New credit: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              FutureBuilder(
                                  future: widget.user.fetchDoubleCredit(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          "€${(snapshot.data! - totalPrice).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black));
                                    } else {
                                      return const Text("Loading...",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                Reservation newReservation = Reservation(
                                  userID: widget.user.id,
                                  itemID: widget.item.itemID,
                                  startDate: DateFormat('dd-MM-y HH:mm')
                                      .format(widget.startDateTime),
                                  endDate: DateFormat('dd-MM-y HH:mm')
                                      .format(widget.endDateTime),
                                  status: "Reserved",
                                );

                                //Deduct credit from user
                                if (await widget.user
                                    .hasEnoughCredit(totalPrice)) {
                                  widget.user.deductCredit(totalPrice);

                                  //Create reservation in database
                                  widget.user.createReservation(newReservation);

                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReservingItemConfirmation(
                                        currentUser: widget.user,
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
                              child: const Text('Confirm & Pay Reservation'),
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${widget.user.name}, only payment has to be completed before you can use:",
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        Text(widget.item.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
