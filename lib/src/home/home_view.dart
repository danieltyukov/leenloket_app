import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:leenloket_app/src/sample_feature/sample_item.dart';

import '../sample_feature/sample_item_details_view.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  final List<SampleItem> items;

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Hello, Fred'), actions: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: const ProfilePicture(
                name: 'Fred',
                radius: 25,
                fontsize: 21,
                img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
              ),
            ),
            onTap: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          )
        ]),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.transparent,
                  height: 250,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                            width: 150,
                            height: 180,
                            margin: EdgeInsets.only(right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigate to the details page. If the user leaves and returns to
                                          // the app after it has been killed while running in the
                                          // background, the navigation stack is restored.
                                          Navigator.restorablePushNamed(
                                            context,
                                            SampleItemDetailsView.routeName,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.asset(
                                            'assets/images/drill.jpg',
                                            fit: BoxFit.cover,
                                            height: 180,
                                            width: 150,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Drill",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ));
                      }),
                )
              ],
            ),
          )),
        ));
  }
}
