class Category {
  final String categoryName;

  Category({required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryName: json['CategoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryName': categoryName,
    };
  }
}
