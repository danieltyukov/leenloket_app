import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:leenloket_app/src/admin/admin__items__index.dart';
import 'package:leenloket_app/src/widgets/customButton.dart';

class AdminCreateItem extends StatefulWidget {
  const AdminCreateItem({Key? key}) : super(key: key);

  static const routeName = '/admin/items';

  @override
  State<AdminCreateItem> createState() => _AdminCreateItemState();
}

class _AdminCreateItemState extends State<AdminCreateItem> {
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final lockerController = TextEditingController();
  final itemIDController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Home'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            CustomButton(
              title: 'Add item',
              color: Colors.orange,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (contenxt) {
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const Text(
                              "Add item",
                            ),
                            TextField(
                              controller: itemIDController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(helperText: "Item ID"),
                            ),
                            TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                  helperText: "Item description"),
                            ),
                            TextField(
                              controller: categoryController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(helperText: "Category"),
                            ),
                            TextField(
                              controller: lockerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  helperText: "Locker ID"),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  DatabaseReference dbRef =
                                      FirebaseDatabase.instance.ref();

                                  Map<String, dynamic> data = {
                                    "itemID": itemIDController.value.toString(),
                                    "description":
                                        descriptionController.value.toString(),
                                    "categoryID":
                                        categoryController.value.toString(),
                                    "lockerID":
                                        lockerController.value.toString(),
                                    "status": "Available"
                                  };

                                  dbRef.child('Items').push().set(data).then(
                                      (value) => Navigator.of(context).pop());
                                },
                                child: const Text("Add item"))
                          ]),
                        ),
                      );
                    });
              },
            ),
            CustomButton(
              title: 'See all items',
              color: Colors.red,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminIndexItems.routeName);
              },
            ),
          ],
        ),
      );
}
