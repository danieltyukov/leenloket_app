class Locker {
  final String location;
  final String status;

  Locker({required this.location, required this.status});

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      location: json['Location'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Location': location,
      'Status': status,
    };
  }
}
