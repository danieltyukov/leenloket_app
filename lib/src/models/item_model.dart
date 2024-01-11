import 'package:Leenloket/src/models/location_model.dart';
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

  //Get the location name of the locker where the item is stored
  Future<String> getLocationName() async {
    String locationID = '';
    late DatabaseReference lockerRef =
        FirebaseDatabase.instance.ref('Lockers/$lockerID');

    DataSnapshot snapshot = await lockerRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      locationID = values['Location'];
    }

    late DatabaseReference locationRef =
        FirebaseDatabase.instance.ref('Locations/$locationID');

    DataSnapshot locationSnapshot = await locationRef.get();

    String locationName = '';

    if (locationSnapshot.exists) {
      Map<dynamic, dynamic> values = locationSnapshot.value as Map;
      locationName = values['LocationName'];
    }

    return locationName;
  }

  //Get location in Location model
  Future<Locations> getLocation() async {
    String locationID = '';
    late DatabaseReference lockerRef =
        FirebaseDatabase.instance.ref('Lockers/$lockerID');

    DataSnapshot snapshot = await lockerRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      locationID = values['Location'];
    }

    late DatabaseReference locationRef =
        FirebaseDatabase.instance.ref('Locations/$locationID');

    DataSnapshot locationSnapshot = await locationRef.get();

    late Locations location;

    if (locationSnapshot.exists) {
      Map<dynamic, dynamic> values = locationSnapshot.value as Map;
      location = Locations(
          id: locationSnapshot.key!,
          lat: values['lat'],
          long: values['long'],
          locationName: values['LocationName']);
    }

    return location;
  }
}
