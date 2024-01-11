import 'package:Leenloket/src/utils/authentication_functions.dart';
import 'package:Leenloket/src/views/authentication/auth__onboarding_view.dart';
import 'package:Leenloket/src/views/user/home/components/side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView(
      {super.key, required this.controller, required this.currentUser});

  static const routeName = '/settings';

  final UserModel.User currentUser;

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: SideMenu(
        currentUser: currentUser,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
