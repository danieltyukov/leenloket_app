import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_2__payment.dart';
import 'package:flutter/material.dart';

class ReservingItemStep1 extends StatefulWidget {
  final Item item;
  final UserModel.User user;
  final DateTime startDate;
  final DateTime endDate;

  const ReservingItemStep1(
      {super.key,
      required this.item,
      required this.user,
      required this.startDate,
      required this.endDate});

  static const routeName = '/reserving/new/step1';

  @override
  State<ReservingItemStep1> createState() => _ReservingItemStep1State();
}

class _ReservingItemStep1State extends State<ReservingItemStep1> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Stack(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.15),
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
                            const Text('Step 1 of 2: Checkout',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 30),
                            const Text('Your credentials',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Name: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(widget.user.name,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Email: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(widget.user.email,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Phone: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(widget.user.phone,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Text('Item',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Name: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(widget.item.itemName,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Price per day: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        "€${widget.item.pricePerDay.toString()}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
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
                                        "${widget.startDate.day}/${widget.startDate.month}/${widget.startDate.year} ${widget.startDate.hour}:${widget.startDate.minute.toString().padLeft(2, '0')}",
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
                                        "${widget.endDate.day}/${widget.endDate.month}/${widget.endDate.year} ${widget.endDate.hour}:${widget.endDate.minute.toString().padLeft(2, '0')}",
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
                            const Text('Total price',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Total days: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        "${widget.endDate.difference(widget.startDate).inDays} days",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Total price: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        "€${int.parse(widget.item.pricePerDay) * widget.endDate.difference(widget.startDate).inDays}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ReservingItemStep2.routeName,
                                      arguments: {
                                        "item": widget.item,
                                        "user": widget.user,
                                        "startDateTime": widget.startDate,
                                        "endDateTime": widget.endDate
                                      });
                                },
                                child: const Text('Next'),
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
                              "${widget.user.name}, you're starting a new reservation for:",
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
        ));
  }
}
