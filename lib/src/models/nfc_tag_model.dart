class NFCTag {
  final int tagID;
  final int itemID;
  final String status;

  NFCTag({required this.tagID, required this.itemID, required this.status});

  Map<String, dynamic> toJson() => {
        'TagID': tagID,
        'ItemID': itemID,
        'Status': status,
      };

  static NFCTag fromJson(Map<String, dynamic> json) => NFCTag(
        tagID: json['TagID'],
        itemID: json['ItemID'],
        status: json['Status'],
      );
}
