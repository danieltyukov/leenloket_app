import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:Leenloket/src/admin/admin__items__index.dart';
import 'package:Leenloket/src/admin/reservations/admin__reservations__index.dart';
import 'package:Leenloket/src/home/admin__home_view.dart';
import 'package:Leenloket/src/reservations/user__reservations__index.dart';
import 'package:Leenloket/src/shop/shop__index_view.dart';
import 'package:Leenloket/src/shop/shop__item__single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  static const routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ref = FirebaseDatabase.instance.ref('Items');
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePageView(),
      const SampleItemListView(),
      const UserReservationsIndex(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Hello, Friend"), actions: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: const ProfilePicture(
              name: "Fred",
              radius: 25,
              fontsize: 21,
            ),
          ),
          onTap: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        )
      ]),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFD7263D),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'My Reservations',
          ),
        ],
      ),
    );
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
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
