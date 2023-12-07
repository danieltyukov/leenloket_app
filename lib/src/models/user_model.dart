class User {
  final int userID;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String paymentDetails;
  final int roleID;

  User({
    required this.userID,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.paymentDetails,
    required this.roleID,
  });

  Map<String, dynamic> toJson() => {
        'UserID': userID,
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Address': address,
        'Payment_Details': paymentDetails,
        'RoleID': roleID,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        userID: json['UserID'],
        name: json['Name'],
        email: json['Email'],
        phone: json['Phone'],
        address: json['Address'],
        paymentDetails: json['Payment_Details'],
        roleID: json['RoleID'],
      );
}
