class NFCTag {
  final String itemID;
  final String status;

  NFCTag({required this.itemID, required this.status});

  factory NFCTag.fromJson(Map<String, dynamic> json) {
    return NFCTag(
      itemID: json['ItemID'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemID': itemID,
      'Status': status,
    };
  }
}
