import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:leenloket_app/src/shop/shop__item__single_view.dart';
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

  Future<User?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user;
    } else {
      return null; // User is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUserId(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('Data not available');
          } else {
            User user = snapshot.data!;
            String userName = user.displayName ?? "Fred";
            String userPicture = user.photoURL ?? "";

            return Scaffold(
                appBar: AppBar(title: Text("Hello, $userName"), actions: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: ProfilePicture(
                        name: userName,
                        radius: 25,
                        fontsize: 21,
                        img: userPicture,
                      ),
                    ),
                    onTap: () {
                      Navigator.restorablePushNamed(
                          context, SettingsView.routeName);
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
                              padding:
                                  const EdgeInsets.only(top: 25, bottom: 25),
                              child: Image.asset('assets/images/logo.png'),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 250,
                          child: FirebaseAnimatedList(
                            query: ref,
                            itemBuilder: (context, snapshot, animation, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShopItemSingleView(
                                          itemId: snapshot.key!)));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(snapshot
                                        .child('Title')
                                        .value
                                        .toString()),
                                    subtitle: Text(
                                        "ID: ${snapshot.child('ItemID').value}"),
                                    trailing: Text(snapshot
                                        .child('Status')
                                        .value
                                        .toString()),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )),
                ));
            ;
          }
        });
  }
}
