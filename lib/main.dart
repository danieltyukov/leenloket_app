import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/views/user/settings/settings_controller.dart';
import 'src/views/user/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure that Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
