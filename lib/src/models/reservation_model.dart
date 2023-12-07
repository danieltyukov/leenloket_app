class Reservation {
  final int reservationID;
  final int userID;
  final int itemID;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Reservation({
    required this.reservationID,
    required this.userID,
    required this.itemID,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'ReservationID': reservationID,
        'UserID': userID,
        'ItemID': itemID,
        'StartDate': startDate.toIso8601String(),
        'EndDate': endDate.toIso8601String(),
        'Status': status,
      };

  static Reservation fromJson(Map<String, dynamic> json) => Reservation(
        reservationID: json['ReservationID'],
        userID: json['UserID'],
        itemID: json['ItemID'],
        startDate: DateTime.parse(json['StartDate']),
        endDate: DateTime.parse(json['EndDate']),
        status: json['Status'],
      );
}
