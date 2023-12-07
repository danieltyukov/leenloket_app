import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminItemCreate extends StatefulWidget {
  const AdminItemCreate({super.key});

  static const routeName = '/admin/items/create';

  @override
  State<AdminItemCreate> createState() => _AdminItemCreateState();
}

class _AdminItemCreateState extends State<AdminItemCreate> {
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final lockerController = TextEditingController();
  final itemIDController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create'),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              "Add item",
            ),
            TextField(
              controller: itemIDController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(helperText: "Item ID"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(helperText: "Item description"),
            ),
            TextField(
              controller: categoryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(helperText: "Category"),
            ),
            TextField(
              controller: lockerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(helperText: "Locker ID"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

                  try {
                    int itemID = int.parse(itemIDController.value.text);
                    String description = descriptionController.value.text;
                    int categoryID = int.parse(categoryController.value.text);
                    int lockerID = int.parse(lockerController.value.text);

                    Map<String, dynamic> data = {
                      "ItemID": itemID,
                      "Description": description,
                      "CategoryID": categoryID,
                      "LockerID": lockerID,
                      "Status": "Available",
                      "Price": "0.00",
                      "Title": "Title",
                    };

                    dbRef
                        .child('Items')
                        .push()
                        .set(data)
                        .then((value) => Navigator.of(context).pop());
                  } catch (e) {
                    // Handle parsing errors, for example, show an error message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Invalid input. Please enter valid numeric values.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the error dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text("Add item"))
          ]),
        ),
      );
}
