import 'package:Leenloket/src/models/credit_transaction_model.dart';
import 'package:Leenloket/src/models/reservation_model.dart';
import 'package:Leenloket/src/utils/reservationCode_functions.dart';
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

  ////////////////////////////////////////////
  ////////////////////////////////////////////
  ///        User Mehtods                  ///
  ////////////////////////////////////////////
  ////////////////////////////////////////////

  // Get roleID of the user
  Future<String> fetchRoleID() async {
    late DatabaseReference _userRef =
        FirebaseDatabase.instance.ref('Users/$id');
    DataSnapshot snapshot = await _userRef.get();

    return snapshot.child('RoleID').value.toString();
  }

  // Return user name
  Future<String> fetchName() async {
    return name;
  }

  ////////////////////////////////////////////
  ////////////////////////////////////////////
  ///        Credit Mehtods                ///
  ////////////////////////////////////////////
  ////////////////////////////////////////////

  // Check if credit exists
  Future<bool> hasCreditHolder() async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders');
    DataSnapshot snapshot = await creditsRef.get();
    bool hasCredit = false;

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['UserID'] == id) {
          hasCredit = true;
        }
      });
    }

    return hasCredit;
  }

  // Create credit for the user
  Future<void> createCredit(double amount) async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders');

    await creditsRef.push().set({
      'UserID': id,
      'Credit': amount.toStringAsFixed(2),
    });
  }

  // Fetch the credit of the user
  Future<double> fetchDoubleCredit() async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders');
    DataSnapshot snapshot = await creditsRef.get();
    double credit = 0.00;

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['UserID'] == id) {
          credit = double.parse(value['Credit']);
        }
      });
    }

    return credit;
  }

  // Fetch the creditID of the user
  Future<String> fetchCreditID() async {
    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders');
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

  // Top up the credit of the user
  Future<void> topCredit(double amount) async {
    String creditID = await fetchCreditID();
    double credit = await fetchDoubleCredit();

    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders/$creditID');

    await creditsRef.update({
      'Credit': (credit + amount).toStringAsFixed(2),
    });
  }

  // Deduct the credit of the user
  Future<void> deductCredit(double amount) async {
    String creditID = await fetchCreditID();
    double credit = await fetchDoubleCredit();

    late DatabaseReference creditsRef =
        FirebaseDatabase.instance.ref('CreditHolders/$creditID');

    //Create transaction in database
    createCreditTransaction("Item Reservation", -amount);

    await creditsRef.update({
      'Credit': (credit - amount).toStringAsFixed(2),
    });
  }

  // Check if the user has enough credit
  Future<bool> hasEnoughCredit(double amount) async {
    double credit = await fetchDoubleCredit();
    return credit >= amount;
  }

  ////////////////////////////////////////////
  ////////////////////////////////////////////
  ///   Credit Transaction Mehtods         ///
  ////////////////////////////////////////////
  ////////////////////////////////////////////

  // Create a credit transaction
  Future<void> createCreditTransaction(String type, double amount) async {
    late DatabaseReference creditTransactionsRef =
        FirebaseDatabase.instance.ref('CreditTransactions');

    await creditTransactionsRef.push().set({
      'UserID': id,
      'CreditHolderID': await fetchCreditID(),
      'Type': type,
      'Amount': amount.toStringAsFixed(2),
      'Date': DateTime.now().toString(),
    });
  }

  // Get all credit transactions of the user
  Future<List<CreditTransaction>> fetchCreditTransactions() async {
    late DatabaseReference creditTransactionsRef =
        FirebaseDatabase.instance.ref('CreditTransactions');
    DataSnapshot snapshot = await creditTransactionsRef.get();
    List<CreditTransaction> creditTransactions = [];

    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        if (value['UserID'] == id) {
          // Only add transactions with the specified user ID
          CreditTransaction ct = CreditTransaction(
            id: key,
            amount: double.parse(value['Amount']),
            userID: value['UserID'],
            creditHolderID: value['CreditHolderID'],
            type: value['Type'],
            date: value['Date'],
          );
          creditTransactions.add(ct);
        }
      });
    }

    return creditTransactions;
  }

  ////////////////////////////////////////////
  ////////////////////////////////////////////
  ///        Reservation Mehtods           ///
  ////////////////////////////////////////////
  ////////////////////////////////////////////

  // Create a reservation for the user
  Future<void> createReservation(Reservation reservation) async {
    late DatabaseReference reservationsRef =
        FirebaseDatabase.instance.ref('Reservations');
    late DatabaseReference dbRefCodes = FirebaseDatabase.instance.ref('Codes');

    DatabaseReference newReservationRef = reservationsRef.push();

    int reservationCode = createReservationCode();

    await newReservationRef.set({
      'UserID': reservation.userID,
      'ItemID': reservation.itemID,
      'StartDate': reservation.startDate,
      'EndDate': reservation.endDate,
      'Status': reservation.status,
    }).then((reservation) => {
          dbRefCodes.push().set({
            "Code": "QRCODEHERE",
            "PINCode": "$reservationCode",
            "ReservationID": newReservationRef.key,
          }),
        });
  }
}
