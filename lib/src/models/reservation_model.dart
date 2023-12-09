class Reservation {
  final String userID;
  final String itemID;
  final String startDate;
  final String endDate;
  final String status;

  Reservation(
      {required this.userID,
      required this.itemID,
      required this.startDate,
      required this.endDate,
      required this.status});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      userID: json['UserID'],
      itemID: json['ItemID'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'ItemID': itemID,
      'StartDate': startDate,
      'EndDate': endDate,
      'Status': status,
    };
  }
}
