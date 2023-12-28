import 'package:Leenloket/src/views/user/home/home_view.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_service.dart';
import 'package:Leenloket/src/views/user/settings/settings_view.dart';
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
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(1.0),
                  bottomRight: Radius.circular(1.0),
                ),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/bg.jpeg'))),
            child: Text('DevHubSpot',
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(currentIndex: 0)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(currentIndex: 1)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_pin_outlined),
            title: const Text("Team"),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(currentIndex: 2)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.more_horiz_outlined),
            title: const Text("More"),
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
