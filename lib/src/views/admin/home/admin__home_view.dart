import 'package:Leenloket/src/utils/authentication_functions.dart';
import 'package:Leenloket/src/views/admin/Categories/admin__categories__index.dart';
import 'package:Leenloket/src/views/admin/items/admin__items__index.dart';
import 'package:Leenloket/src/views/admin/locations/admin__locations__index.dart';
import 'package:Leenloket/src/views/admin/lockers/admin__lockers__index.dart';
import 'package:Leenloket/src/views/admin/reservations/admin__reservations__index.dart';
import 'package:Leenloket/src/views/admin/users/admin__users__index.dart';
import 'package:Leenloket/src/views/authentication/auth__onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/widgets/customButton.dart';

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
          actions: [
            //logout
            IconButton(
              onPressed: () async {
                await firebaseLogout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OnboardingView.routeName,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            CustomButton(
              title: 'Items',
              color: Colors.orange,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminIndexItems.routeName);
              },
            ),
            CustomButton(
              title: 'Reservations',
              color: Colors.red,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminReservationsIndex.routeName);
              },
            ),
            CustomButton(
              title: 'Categories',
              color: Colors.green,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdimCategoriesIndex.routeName);
              },
            ),
            CustomButton(
              title: 'Lockers',
              color: Colors.blue,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminLockersIndex.routeName);
              },
            ),
            CustomButton(
              title: 'Users',
              color: Colors.purple,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminUsersIndex.routeName);
              },
            ),
            CustomButton(
              title: 'Locations',
              color: Colors.yellow,
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AdminLocationsIndex.routeName);
              },
            ),
          ],
        ),
      );
}
