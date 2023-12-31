class Locations {
  final String id;
  final String locationName;
  final String lat;
  final String long;

  Locations(
      {required this.id,
      required this.lat,
      required this.long,
      required this.locationName});

  factory Locations.fromJson(Map<String, dynamic> json, key) {
    return Locations(
      id: key,
      locationName: json['LocationName'],
      lat: json['Lat'],
      long: json['Long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LocationName': locationName,
      'Lat': lat,
      'Long': long,
    };
  }
}
