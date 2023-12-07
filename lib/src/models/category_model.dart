class Category {
  final int categoryID;
  final String categoryName;

  Category({required this.categoryID, required this.categoryName});

  Map<String, dynamic> toJson() => {
        'CategoryID': categoryID,
        'CategoryName': categoryName,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        categoryID: json['CategoryID'],
        categoryName: json['CategoryName'],
      );
}
