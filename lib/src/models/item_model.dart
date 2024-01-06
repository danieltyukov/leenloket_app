class Item {
  final String itemID;
  final String itemName;
  final String pricePerDay;
  final String description;
  final String status;
  final String categoryID;
  final String lockerID;
  final String imageUrl;

  Item({
    required this.itemID,
    required this.itemName,
    required this.pricePerDay,
    required this.description,
    required this.status,
    required this.categoryID,
    required this.lockerID,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json, key) {
    return Item(
      itemID: key,
      itemName: json['ItemName'],
      pricePerDay: json['PricePerDay'],
      description: json['Description'],
      status: json['Status'],
      categoryID: json['CategoryID'],
      lockerID: json['LockerID'],
      imageUrl: json['ImageUrl'],
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
      'ImageUrl': imageUrl,
    };
  }
}
