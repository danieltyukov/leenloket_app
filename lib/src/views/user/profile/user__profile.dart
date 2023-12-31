import 'package:Leenloket/src/utils/authentication_functions.dart';
import 'package:Leenloket/src/views/authentication/auth__onboarding_view.dart';
import 'package:Leenloket/src/views/user/home/components/side_menu.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_service.dart';
import 'package:Leenloket/src/views/user/settings/settings_view.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  static const routeName = '/user/profile';

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late UserModel.User user;
  late SettingsController _settingsController;
  late Future<User> fireBaseUser;

  @override
  void initState() {
    super.initState();
    fireBaseUser = getCurrentAuthenticatedFirebaseUser();
    // Instantiate SettingsController in initState
    _settingsController = SettingsController(SettingsService());
    // Load settings when the widget is initialized
    _settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red.withOpacity(0.4),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: fireBaseUser,
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.email!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const Text('Loading...');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide.none,
                        foregroundColor: Colors.white),
                    child: const Text('Edit Profile')),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 30,
              ),
              ProfileMenuTile(
                title: 'My reservations',
                icon: Icons.calendar_today,
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserReservationsIndex()));
                },
                endIcon: true,
                buttonColor: Colors.red,
              ),
              ProfileMenuTile(
                title: 'My credit',
                icon: Icons.euro,
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserReservationsIndex()));
                },
                endIcon: true,
                buttonColor: Colors.red,
              ),
              const SizedBox(
                height: 30,
              ),
              ProfileMenuTile(
                title: 'Settings',
                icon: Icons.settings,
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsView(
                            controller: _settingsController,
                          )));
                },
                endIcon: true,
                buttonColor: Colors.red,
              ),
              const SizedBox(
                height: 60,
              ),
              ProfileMenuTile(
                title: 'Logout',
                icon: Icons.logout,
                press: () async {
                  await firebaseLogout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OnboardingView.routeName,
                    (route) => false,
                  );
                },
                endIcon: false,
                buttonColor: Colors.blue,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    required this.endIcon,
    required this.buttonColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;
  final bool endIcon;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(title),
      trailing: Icon(endIcon ? Icons.arrow_forward_ios : null),
      onTap: press,
    );
  }
}
