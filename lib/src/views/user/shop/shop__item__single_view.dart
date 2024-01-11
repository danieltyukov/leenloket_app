import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_0__credentials.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class ShopItemSingleView extends StatefulWidget {
  final String itemId;

  const ShopItemSingleView(
      {super.key,
      required this.itemId,
      required this.selectedStartDate,
      required this.selectedEndDate});

  static const routeName = '/shop/items/single';

  final DateTime selectedStartDate;
  final DateTime selectedEndDate;

  @override
  State<ShopItemSingleView> createState() => _ShopItemSingleView();
}

class _ShopItemSingleView extends State<ShopItemSingleView> {
  late DatabaseReference _itemRef;
  final _categoryRef = FirebaseDatabase.instance.ref('Categories');
  String _categoryName = '';
  String selectedDay = '';
  String selectedEndDay = '';
  List<String> next7Days = [];
  List<String> next7EndDays = [];
  String selectedTime = '';
  String selectedEndTime = '';
  List<String> timeList = [];
  late DateTime startDate;
  late DateTime endDate;

  void updateStartDate(DateTime newStartDate) {
    setState(() {
      startDate = newStartDate;
      next7EndDays = generateNext7Days(startDate);

      if (startDate.isAfter(endDate)) {
        endDate = startDate.add(const Duration(days: 1));
      }
    });
  }

  void updateEndDate(DateTime newEndDate) {
    setState(() {
      endDate = newEndDate;
    });
  }

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
    startDate = widget.selectedStartDate;
    endDate = widget.selectedEndDate;
    next7Days = generateNext7Days(DateTime.now());
    next7EndDays = generateNext7Days(startDate);
    selectedDay = next7Days[0];
    selectedEndDay = next7EndDays[0];
    timeList = generateTimeList();
    selectedTime = timeList[0];
    selectedEndTime = timeList[0];
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
      body: Stack(
        children: [
          FutureBuilder<DatabaseEvent>(
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
                  description:
                      itemSnapshot.child('Description').value.toString(),
                  pricePerDay:
                      itemSnapshot.child('PricePerDay').value.toString(),
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
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.red, Colors.indigo.shade900],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 2),
                                    blurRadius: 4.0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //show diaglog where user can select end and start date
                                      selectNewStartDateTime(context);
                                    },
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Pickup",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        Text(
                                          "${startDate.day} ${getMonthNameShort(startDate.month)} ${startDate.hour}:${startDate.minute}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //show diaglog where user can select end and start date
                                      selectNewEndDateTime(context);
                                    },
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Return",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        Text(
                                          "${endDate.day} ${getMonthNameShort(endDate.month)} ${endDate.hour}:${endDate.minute}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                          FutureBuilder(
                              future:
                                  currentItem.isAvailable(startDate, endDate),
                              builder: (context, AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('Data not available');
                                } else {
                                  if (snapshot.data.toString() == 'true') {
                                    return const Text(
                                      'Available',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    );
                                  } else {
                                    return const Text(
                                      'Not Available',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    );
                                  }
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
        ],
      ),
    );
  }

  Future<DatabaseEvent> _fetchItemDetails() async {
    return await _itemRef.once();
  }

  Future<dynamic> selectNewStartDateTime(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Select pickup date and time",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: generateNext7Days(DateTime.now())
                                        .length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDay = next7Days[index];
                                            print(selectedDay);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(
                                            next7Days[index],
                                            style: TextStyle(
                                              color: selectedDay ==
                                                      next7Days[index]
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: timeList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedTime = timeList[index];
                                            print(selectedTime);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(timeList[index],
                                              style: TextStyle(
                                                color: selectedTime ==
                                                        timeList[index]
                                                    ? Colors.red
                                                    : Colors.black,
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Get date, month, year, hour and minute from selected date and time in separate variables
                          DateTime newStartDate = combineDateAndTime(
                              parseFormattedDay(selectedDay), selectedTime);

                          // Update the state with the new start date
                          updateStartDate(newStartDate);

                          print(startDate);

                          Navigator.pop(context);
                        },
                        child: const Text('Adjust'),
                      ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }

  Future<dynamic> selectNewEndDateTime(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Select return date and time",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        generateNext7Days(startDate).length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedEndDay =
                                                next7EndDays[index];
                                            print(selectedDay);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(
                                            next7EndDays[index],
                                            style: TextStyle(
                                              color: selectedEndDay ==
                                                      next7EndDays[index]
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: timeList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedEndTime = timeList[index];
                                            print(selectedTime);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(timeList[index],
                                              style: TextStyle(
                                                color: selectedEndTime ==
                                                        timeList[index]
                                                    ? Colors.red
                                                    : Colors.black,
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Get date, month, year, hour and minute from selected date and time in separate variables
                          DateTime newEndDate = combineDateAndTime(
                              parseFormattedDay(selectedEndDay),
                              selectedEndTime);

                          // Update the state with the new start date
                          updateEndDate(newEndDate);

                          print(startDate);

                          Navigator.pop(context);
                        },
                        child: const Text('Adjust'),
                      ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }
}
