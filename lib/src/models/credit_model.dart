import 'package:firebase_database/firebase_database.dart';

class Credit {
  final double credit;
  final String userID;

  Credit({
    required this.credit,
    required this.userID,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      credit: json['Credit'],
      userID: json['UserID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'Credit': credit,
    };
  }
}
