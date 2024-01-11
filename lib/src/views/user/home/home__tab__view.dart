import 'package:Leenloket/src/views/user/shop/shop__item__single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

class HomePageView extends StatefulWidget {
  HomePageView({
    super.key,
    required this.currentUser,
    required this.initialStartDate,
    required this.initialEndDate,
  });

  final UserModel.User currentUser;

  final DateTime initialStartDate;
  final DateTime initialEndDate;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final ref = FirebaseDatabase.instance.ref('Items');
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

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Generate box with start and end date selector
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      fontSize: 12, color: Colors.white)),
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
                                      fontSize: 12, color: Colors.white)),
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
                              builder: (context) => ShopItemSingleView(
                                  currentUser: widget.currentUser,
                                  selectedEndDate: endDate,
                                  selectedStartDate: startDate,
                                  itemId: snapshot.key!)));
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
