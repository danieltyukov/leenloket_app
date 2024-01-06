import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_0__credentials.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class ShopItemSingleView extends StatefulWidget {
  final String itemId;

  const ShopItemSingleView({super.key, required this.itemId});

  static const routeName = '/shop/items/single';

  @override
  State<ShopItemSingleView> createState() => _ShopItemSingleView();
}

class _ShopItemSingleView extends State<ShopItemSingleView> {
  late DatabaseReference _itemRef;
  final _categoryRef = FirebaseDatabase.instance.ref('Categories');
  String _categoryName = '';

  Future<void> fetchCategory(String itemId) async {
    final item = FirebaseDatabase.instance.ref('Items/${widget.itemId}');

    DataSnapshot itemSnapshot = await item.get();
    DataSnapshot categorySnapshot = await _categoryRef.get();

    String categoryId = itemSnapshot.child('CategoryID').value.toString();

    String categoryName = '';

    if (categorySnapshot.exists) {
      Map<dynamic, dynamic> values = categorySnapshot.value as Map;
      values.forEach((key, value) {
        if (key == categoryId) {
          categoryName = value['CategoryName'];
        }
      });
    }

    setState(() {
      _categoryName = categoryName;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize DatabaseReference for the specific item
    _itemRef = FirebaseDatabase.instance.ref('Items/${widget.itemId}');
    fetchCategory(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    late UserModel.User currentUser;

    Future<UserModel.User> getUser() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseDatabase.instance.ref("Users/$uid");
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final user = UserModel.User.fromJson(data, uid);
        currentUser = user;
        return user;
      } else {
        throw Exception('User not found');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: _fetchItemDetails(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('Data not available');
          } else {
            DataSnapshot itemSnapshot = snapshot.data!.snapshot;
            String image = itemSnapshot.child('ImageUrl').value.toString();

            Item currentItem = Item(
              itemID: itemSnapshot.key!,
              itemName: itemSnapshot.child('ItemName').value.toString(),
              description: itemSnapshot.child('Description').value.toString(),
              pricePerDay: itemSnapshot.child('PricePerDay').value.toString(),
              status: itemSnapshot.child('Status').value.toString(),
              categoryID: itemSnapshot.child('CategoryID').value.toString(),
              lockerID: itemSnapshot.child('LockerID').value.toString(),
              imageUrl: itemSnapshot.child('ImageUrl').value.toString(),
            );

            // Display details for the specific item
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child: FanCarouselImageSlider(
                          sliderHeight: 300,
                          autoPlay: true,
                          imagesLink: [image],
                          isAssets: false,
                          initalPageIndex: 0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                  itemSnapshot
                                      .child('ItemName')
                                      .value
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                  _categoryName, // Replace with the actual category if needed
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                          Text(
                              "€${itemSnapshot.child('PricePerDay').value.toString()}",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              itemSnapshot
                                  .child('Description')
                                  .value
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400))),
                      const SizedBox(height: 20),
                      FutureBuilder(
                          future: getUser(),
                          builder: (context,
                              AsyncSnapshot<UserModel.User> snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReservingItemStep0(
                                                      item: currentItem,
                                                      user: currentUser)));
                                    },
                                    child: const Text("Rent this item"),
                                  )
                                ],
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<DatabaseEvent> _fetchItemDetails() async {
    return await _itemRef.once();
  }
}
