import 'package:Leenloket/src/utils/rive_utils.dart';
import 'package:Leenloket/src/views/user/favorites/user__favorites__index.dart';
import 'package:Leenloket/src/views/user/home/components/animated_bar.dart';
import 'package:Leenloket/src/views/user/home/components/side_menu.dart';
import 'package:Leenloket/src/views/user/profile/user__profile.dart';
import 'package:Leenloket/src/views/user/settings/settings_controller.dart';
import 'package:Leenloket/src/views/user/settings/settings_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/views/user/shop/shop__index_view.dart';
import 'package:Leenloket/src/views/user/shop/shop__item__single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rive/rive.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatefulWidget {
  HomeView({
    required this.currentIndex,
    super.key,
  });

  int currentIndex = 0;
  static const routeName = '/home';

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
      HomePageView(),
      const SampleItemListView(),
      const UserFavoriteItems(),
      const UserProfileView(),
    ];

    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(),
        body: pages[widget.currentIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(24)),
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

class HomePageView extends StatelessWidget {
  HomePageView({
    super.key,
  });

  final ref = FirebaseDatabase.instance.ref('Items');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 229, 77, 77),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 25),
                    child: Image.asset('assets/images/logo.png'),
                  )),
              const SizedBox(height: 20),
              Container(
                color: Colors.transparent,
                height: 250,
                child: FirebaseAnimatedList(
                  query: ref.orderByChild('Status').equalTo('Available'),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.child('Status').value.toString() ==
                        'Available') {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ShopItemSingleView(itemId: snapshot.key!)));
                        },
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 80, // Set your desired width
                              height: 60, // Set your desired height
                              child: CachedNetworkImage(
                                imageUrl:
                                    snapshot.child('ImageUrl').value.toString(),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit
                                    .cover, // Ensures the image covers the container
                              ),
                            ),
                            title: Text(
                                snapshot.child('ItemName').value.toString()),
                            subtitle: Text(
                                "€${snapshot.child('PricePerDay').value} per day"),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
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
