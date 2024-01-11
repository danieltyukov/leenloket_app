import 'package:Leenloket/src/utils/authentication_functions.dart';
import 'package:Leenloket/src/utils/rive_utils.dart';
import 'package:Leenloket/src/views/user/favorites/user__favorites__index.dart';
import 'package:Leenloket/src/views/user/home/components/animated_bar.dart';
import 'package:Leenloket/src/views/user/home/components/side_menu.dart';
import 'package:Leenloket/src/views/user/home/home__tab__view.dart';
import 'package:Leenloket/src/views/user/profile/user__profile.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_service.dart';
import 'package:Leenloket/src/views/user/shop/shop__index_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

import 'package:rive/rive.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatefulWidget {
  HomeView({
    required this.currentIndex,
    required this.endDate,
    required this.startDate,
    required this.currentUser,
    super.key,
  });

  int currentIndex = 0;
  static const routeName = '/home';

  final UserModel.User currentUser;

  final DateTime startDate;
  final DateTime endDate;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ref = FirebaseDatabase.instance.ref('Items');

  RiveAsset selectedBottomNav = bottomNavs[0];

  late SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    // Instantiate SettingsController in initState
    _settingsController = SettingsController(SettingsService());
    // Load settings when the widget is initialized
    _settingsController.loadSettings();
    selectedBottomNav = bottomNavs[widget.currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePageView(
        initialStartDate: widget.startDate,
        initialEndDate: widget.endDate,
        currentUser: widget.currentUser,
      ),
      SampleItemListView(
        currentUser: widget.currentUser,
      ),
      const UserFavoriteItems(),
      UserProfileView(
        currentUser: widget.currentUser,
      ),
    ];

    return Scaffold(
        drawer: SideMenu(
          currentUser: widget.currentUser,
        ),
        appBar: AppBar(
          title: Text(
            'Hello, ${widget.currentUser.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: pages[widget.currentIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                    bottomNavs.length,
                    (index) => GestureDetector(
                        onTap: () {
                          bottomNavs[index].input!.change(true);
                          if (bottomNavs[index] != selectedBottomNav) {
                            setState(() {
                              selectedBottomNav = bottomNavs[index];
                              widget.currentIndex = index;
                            });
                          }
                          Future.delayed(const Duration(seconds: 2), () {
                            bottomNavs[index].input!.change(false);
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBar(
                              isActive: bottomNavs[index] == selectedBottomNav,
                            ),
                            SizedBox(
                              height: 36,
                              width: 36,
                              child: Opacity(
                                opacity: bottomNavs[index] == selectedBottomNav
                                    ? 1
                                    : 0.5,
                                child: RiveAnimation.asset(
                                  bottomNavs.first.src,
                                  artboard: bottomNavs[index].artboard,
                                  onInit: (artboard) {
                                    StateMachineController controller =
                                        RiveUtils.getRiveController(artboard,
                                            stateMachineName: bottomNavs[index]
                                                .stateMachineName);

                                    bottomNavs[index].input =
                                        controller.findSMI("active") as SMIBool;
                                  },
                                ),
                              ),
                            ),
                          ],
                        )))
              ],
            ),
          ),
        ));
  }
}

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset("assets/rive/navigationbar_icons.riv",
      artboard: "HOME", stateMachineName: "HOME_interactivity", title: "Home"),
  RiveAsset("assets/rive/navigationbar_icons.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "SEARCH"),
  RiveAsset("assets/rive/navigationbar_icons.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      title: "STAR"),
  RiveAsset("assets/rive/navigationbar_icons.riv",
      artboard: "USER", stateMachineName: "USER_Interactivity", title: "ME"),
];
