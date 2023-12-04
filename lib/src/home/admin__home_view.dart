import 'package:flutter/material.dart';
import 'package:leenloket_app/src/admin/admin__items__overview.dart';
import 'package:leenloket_app/src/widgets/customButton.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  static const routeName = '/admin';

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
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
              title: 'Items',
              color: Colors.orange,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminCreateItem.routeName);
              },
            ),
            CustomButton(
              title: 'Reservations',
              color: Colors.red,
              onPressed: () {
                // TODO: Implement button 2 functionality
              },
            ),
          ],
        ),
      );
}
