import 'package:Leenloket/src/models/reservation_model.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__single.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/views/user/home/home_view.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

class ReservingItemConfirmation extends StatefulWidget {
  final Reservation reservation;

  const ReservingItemConfirmation(
      {super.key, required this.reservation, required this.currentUser});

  final UserModel.User currentUser;

  static const routeName = '/reserving/confirmation';

  @override
  State<ReservingItemConfirmation> createState() =>
      _ReservingItemConfirmationState();
}

class _ReservingItemConfirmationState extends State<ReservingItemConfirmation> {
  DateTime now = DateTime.now();
  late DateTime roundedNow;

  void getInitialDateTime() {
    roundedNow = DateTime(now.year, now.month, now.day, now.hour);
    print(roundedNow.hour >= 6 && roundedNow.hour < 22);
    if (roundedNow.hour >= 6 && roundedNow.hour < 22) {
      roundedNow = DateTime(now.year, now.month, now.day, now.hour + 1);
    } else {
      roundedNow = DateTime(now.year, now.month, now.day + 1, 06);
    }
  }

  @override
  void initState() {
    super.initState();
    // Instantiate SettingsController in initState
    getInitialDateTime();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                            Text('Your Reservation',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ]),
                          const Text('Lend, use and return',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 30),
                          const Text('Reservation Details',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text('Pickup: ${widget.reservation.startDate}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          Text('Return: ${widget.reservation.endDate}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          //Show two buttons, 1 for homescreen and one for reservation screen
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeView(
                                          currentUser: widget.currentUser,
                                          currentIndex: 0,
                                          startDate: roundedNow,
                                          endDate: roundedNow
                                              .add(const Duration(days: 1))),
                                    ),
                                  );
                                },
                                child: const Text('Home'),
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserReservationsIndex(
                                              currentUser: widget.currentUser),
                                    ),
                                  );
                                },
                                child: const Text('Reservations'),
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
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
                            "${widget.currentUser.name}, your reservation is confirmed!",
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        Text("Thanks for using Leenloket",
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
