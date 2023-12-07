class Transaction {
  final int transactionID;
  final int userID;
  final int itemID;
  final double amount;
  final String paymentMethod;
  final DateTime timestamp;

  Transaction({
    required this.transactionID,
    required this.userID,
    required this.itemID,
    required this.amount,
    required this.paymentMethod,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'TransactionID': transactionID,
        'UserID': userID,
        'ItemID': itemID,
        'Amount': amount,
        'Payment_Method': paymentMethod,
        'Timestamp': timestamp.toIso8601String(),
      };

  static Transaction fromJson(Map<String, dynamic> json) => Transaction(
        transactionID: json['TransactionID'],
        userID: json['UserID'],
        itemID: json['ItemID'],
        amount: json['Amount'],
        paymentMethod: json['Payment_Method'],
        timestamp: DateTime.parse(json['Timestamp']),
      );
}
