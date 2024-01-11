import 'package:firebase_database/firebase_database.dart';

class Locker {
  final String id;
  final String locationID;
  final String status;

  Locker({required this.id, required this.locationID, required this.status});

  factory Locker.fromJson(Map<String, dynamic> json, key) {
    return Locker(
      id: key,
      locationID: json['Location'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Location': locationID,
      'Status': status,
    };
  }

  //Get location from current locker
  Future<String> fetchLocation() async {
    late DatabaseReference locationRef =
        FirebaseDatabase.instance.ref('Locations/$locationID');
    String locationName = "";

    DataSnapshot snapshot = await locationRef.get();

    locationName = snapshot.child('LocationName').value.toString();

    return locationName;
  }
}
