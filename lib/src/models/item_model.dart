class Item {
  final int itemID;
  final String itemName;
  final int pricePerDay;
  final String description;
  final String status;
  final int categoryID;
  final int lockerID;

  Item({
    required this.itemID,
    required this.itemName,
    required this.pricePerDay,
    required this.description,
    required this.status,
    required this.categoryID,
    required this.lockerID,
  });

  Map<String, dynamic> toJson() => {
        'ItemID': itemID,
        'ItemName': itemName,
        'PricePerDay': pricePerDay,
        'Description': description,
        'Status': status,
        'CategoryID': categoryID,
        'LockerID': lockerID,
      };

  static Item fromJson(Map<String, dynamic> json) => Item(
        itemID: json['ItemID'],
        itemName: json['ItemName'],
        pricePerDay: json['PricePerDay'],
        description: json['Description'],
        status: json['Status'],
        categoryID: json['CategoryID'],
        lockerID: json['LockerID'],
      );
}
