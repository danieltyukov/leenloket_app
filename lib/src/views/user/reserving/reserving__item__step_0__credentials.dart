import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_1__period.dart';
import 'package:flutter/material.dart';

class ReservingItemStep0 extends StatefulWidget {
  final Item item;
  final UserModel.User user;

  const ReservingItemStep0({super.key, required this.item, required this.user});

  static const routeName = '/reserving/new/step0';

  @override
  State<ReservingItemStep0> createState() => _ReservingItemStep0State();
}

class _ReservingItemStep0State extends State<ReservingItemStep0> {
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
                  '1',
                  style: TextStyle(
                    color: Colors.white, // Change text color as needed
                    fontSize: 24.0, // Change font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Your information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Item information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Item: ${widget.item.itemName}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Price per day: €${widget.item.pricePerDay}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
          //Button next
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                ReservingItemStep1.routeName,
                arguments: {
                  'item': widget.item,
                  'user': widget.user,
                },
              );
            },
            child: const Text('Next'),
          ),
        ]),
      ),
    );
  }
}
