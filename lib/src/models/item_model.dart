class Item {
  final String itemName;
  final int pricePerDay;
  final String description;
  final String status;
  final String categoryID;
  final String lockerID;

  Item(
      {required this.itemName,
      required this.pricePerDay,
      required this.description,
      required this.status,
      required this.categoryID,
      required this.lockerID});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['ItemName'],
      pricePerDay: json['PricePerDay'],
      description: json['Description'],
      status: json['Status'],
      categoryID: json['CategoryID'],
      lockerID: json['LockerID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemName': itemName,
      'PricePerDay': pricePerDay,
      'Description': description,
      'Status': status,
      'CategoryID': categoryID,
      'LockerID': lockerID,
    };
  }
}
