import 'package:flutter/material.dart';
import 'package:Leenloket/src/home/admin__home_view.dart';
import 'package:Leenloket/src/home/home_view.dart';

class RoleSelectorView extends StatelessWidget {
  const RoleSelectorView({super.key});

  static const routeName = '/role-selector';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Selector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, AdminHomeView.routeName);
              },
              child: const Text('Admin'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, HomeView.routeName);
              },
              child: const Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
