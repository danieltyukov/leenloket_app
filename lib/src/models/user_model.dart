import 'package:firebase_database/firebase_database.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String roleID;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.roleID,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json, key) {
    return User(
      id: key,
      name: json['Name'],
      email: json['Email'],
      phone: json['Phone'],
      address: json['Address'],
      roleID: json['RoleID'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Address': address,
      'RoleID': roleID,
      'Password': password,
    };
  }

  Future<double> fetchDoubleCredit() async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('Credits');
    DataSnapshot snapshot = await creditsRef.get();
    double credit = 0.00;

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['UserID'] == id) {
          credit = value['Credit'] as double;
        }
      });
    }

    return credit;
  }

  Future<String> fetchCreditID() async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('Credits');
    DataSnapshot snapshot = await creditsRef.get();
    String creditID = "";

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['UserID'] == id) {
          creditID = key;
        }
      });
    }

    return creditID;
  }

  Future<void> topCredit(double amount) async {
    String creditID = await fetchCreditID();
    double credit = await fetchDoubleCredit();

    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('Credits/$creditID');

    await creditsRef.update({
      'Credit': credit + amount,
    });
  }
}
