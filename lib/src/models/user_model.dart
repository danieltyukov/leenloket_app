class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String roleID;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.roleID,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['Name'],
      email: json['Email'],
      phone: json['Phone'],
      address: json['Address'],
      roleID: json['RoleID'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Address': address,
      'RoleID': roleID,
      'Password': password,
    };
  }
}
