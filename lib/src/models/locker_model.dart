class Locker {
  final int lockerID;
  final String location;
  final String status;

  Locker(
      {required this.lockerID, required this.location, required this.status});

  Map<String, dynamic> toJson() => {
        'LockerID': lockerID,
        'Location': location,
        'Status': status,
      };

  static Locker fromJson(Map<String, dynamic> json) => Locker(
        lockerID: json['LockerID'],
        location: json['Location'],
        status: json['Status'],
      );
}
