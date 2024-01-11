import 'package:Leenloket/src/views/user/credit/user__credit__view.dart';
import 'package:Leenloket/src/views/user/home/home_view.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_service.dart';
import 'package:Leenloket/src/views/user/settings/settings_view.dart';
import 'package:Leenloket/src/views/user/locations/user__locations__map.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    // Instantiate SettingsController in initState
    _settingsController = SettingsController(SettingsService());
    // Load settings when the widget is initialized
    _settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Image.asset('assets/images/logo.png'),
              )),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(
                      startDate: DateTime.now(),
                      endDate: DateTime.now().add(const Duration(days: 1)),
                      currentIndex: 0)))
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            title: const Text(
              "Shop",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(
                      startDate: DateTime.now(),
                      endDate: DateTime.now().add(const Duration(days: 1)),
                      currentIndex: 1)))
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            title: const Text(
              "Locations",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserLocationsMap()))
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: const Text(
              "My Profile",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(const Duration(days: 1)),
                        currentIndex: 3,
                      )))
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            title: const Text(
              "My Reservations",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserReservationsIndex()))
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SettingsView(controller: _settingsController),
              ))
            },
          )
        ],
      ),
    );
  }
}
