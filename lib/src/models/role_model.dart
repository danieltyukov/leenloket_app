class Role {
  final int roleID;
  final String roleName;

  Role({required this.roleID, required this.roleName});

  Map<String, dynamic> toJson() => {
        'RoleID': roleID,
        'RoleName': roleName,
      };

  static Role fromJson(Map<String, dynamic> json) => Role(
        roleID: json['RoleID'],
        roleName: json['RoleName'],
      );
}
