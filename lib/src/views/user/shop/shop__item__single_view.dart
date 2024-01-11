import 'package:Leenloket/src/models/item_model.dart';
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/views/user/reserving/reserving__item__step_0__credentials.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

/// Displays detailed information about a SampleItem.
class ShopItemSingleView extends StatefulWidget {
  final String itemId;
  final UserModel.User currentUser;

  const ShopItemSingleView(
      {super.key,
      required this.itemId,
      required this.currentUser,
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
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
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
                Size size = MediaQuery.of(context).size;

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Stack(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: size.height * 0.3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Availability",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              FutureBuilder(
                                                  future:
                                                      currentItem.isAvailable(
                                                          startDate, endDate),
                                                  builder: (context,
                                                      AsyncSnapshot<bool>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else if (!snapshot
                                                            .hasData ||
                                                        snapshot.data == null) {
                                                      return const Text(
                                                          'Data not available');
                                                    } else {
                                                      if (snapshot.data
                                                              .toString() ==
                                                          'true') {
                                                        return const Text(
                                                          'Available',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green),
                                                        );
                                                      } else {
                                                        return const Text(
                                                          'Not Available',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        );
                                                      }
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Category",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              Text(
                                                _categoryName,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.red,
                                            Colors.indigo.shade900
                                          ],
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
                                                            color:
                                                                Colors.white)),
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
                                                            color:
                                                                Colors.white)),
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
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      currentItem.description,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Location",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              FutureBuilder(
                                                  future: currentItem
                                                      .getLocationName(),
                                                  builder: (context,
                                                      AsyncSnapshot<String>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else if (!snapshot
                                                            .hasData ||
                                                        snapshot.data == null) {
                                                      return const Text(
                                                          'Data not available');
                                                    } else {
                                                      return Text(
                                                        snapshot.data
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    //Button to rent the item, but only when it is available
                                    FutureBuilder(
                                        future: currentItem.isAvailable(
                                            startDate, endDate),
                                        builder: (context,
                                            AsyncSnapshot<bool> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return const Text(
                                                'Data not available');
                                          } else {
                                            if (snapshot.data.toString() ==
                                                'true') {
                                              return Container(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ReservingItemStep0(
                                                                    item:
                                                                        currentItem,
                                                                    user: widget
                                                                        .currentUser)));
                                                  },
                                                  child: const Text('Rent'),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                width: double.infinity,
                                                child: const ElevatedButton(
                                                  onPressed: null,
                                                  child: Text('Rent'),
                                                ),
                                              );
                                            }
                                          }
                                        }),
                                  ],
                                ),
                              )),
                          ProductTileWithImage(currentItem: currentItem)
                        ]),
                      ),
                    ],
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
                                    itemCount: generateNext7Days(DateTime.now())
                                        .length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedEndDay =
                                                next7EndDays[index];
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(
                                            next7Days[index],
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
                              selectedEndDay);

                          // Update the state with the new start date
                          updateEndDate(newEndDate);

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

class ProductTileWithImage extends StatelessWidget {
  const ProductTileWithImage({
    super.key,
    required this.currentItem,
  });

  final Item currentItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Subtitel",
                style: TextStyle(
                  color: Colors.white,
                )),
            Text(currentItem.itemName,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(text: "Price per day\n"),
                      TextSpan(
                          text: "€${currentItem.pricePerDay}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Image.network(
                    currentItem.imageUrl,
                    fit: BoxFit.fitWidth,
                    height: 170,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
