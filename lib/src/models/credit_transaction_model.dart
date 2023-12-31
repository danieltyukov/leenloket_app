class CreditTransaction {
  final String id;
  final double amount;
  final String userID;
  final String creditHolderID;
  final String type;
  final String date;

  CreditTransaction({
    required this.id,
    required this.amount,
    required this.userID,
    required this.creditHolderID,
    required this.type,
    required this.date,
  });

  factory CreditTransaction.fromJson(Map<String, dynamic> json, key) {
    return CreditTransaction(
      id: key,
      amount: json['Amount'],
      userID: json['UserID'],
      creditHolderID: json['CreditHolderID'],
      type: json['Type'],
      date: json['Date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'CreditHolderID': creditHolderID,
      'Amount': amount,
      'Type': type,
      'Date': date,
    };
  }
}
