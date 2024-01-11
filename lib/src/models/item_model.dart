import 'package:Leenloket/src/utils/datetime_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class Item {
  final String itemID;
  final String itemName;
  final String pricePerDay;
  final String description;
  final String status;
  final String categoryID;
  final String lockerID;
  final String imageUrl;

  Item({
    required this.itemID,
    required this.itemName,
    required this.pricePerDay,
    required this.description,
    required this.status,
    required this.categoryID,
    required this.lockerID,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json, key) {
    return Item(
      itemID: key,
      itemName: json['ItemName'],
      pricePerDay: json['PricePerDay'],
      description: json['Description'],
      status: json['Status'],
      categoryID: json['CategoryID'],
      lockerID: json['LockerID'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemName': itemName,
      'PricePerDay': pricePerDay,
      'Description': description,
      'Status': status,
      'CategoryID': categoryID,
      'LockerID': lockerID,
      'ImageUrl': imageUrl,
    };
  }

  //Check availability of an item, given the start and end date
  Future<bool> isAvailable(DateTime startDate, DateTime endDate) async {
    bool isAvailable = true;
    //Get all reservations from this day forwards
    late DatabaseReference reservationRef =
        FirebaseDatabase.instance.ref('Reservations');

    DataSnapshot snapshot = await reservationRef.get();

    //For each reservation, check if start date and end date is within the reservation

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        DateTime reservationStartDate =
            parseFormattedDayAndTime(value['StartDate'].toString());
        DateTime reservationEndDate =
            parseFormattedDayAndTime(value['EndDate'].toString());

        //If reservation conflicts with the start and end date, then item is not available
        if ((startDate.isAfter(reservationStartDate) &&
                startDate.isBefore(reservationEndDate)) ||
            (endDate.isAfter(reservationStartDate) &&
                endDate.isBefore(reservationEndDate))) {
          isAvailable = false;
        }
      });
    }

    return isAvailable;
  }
}
