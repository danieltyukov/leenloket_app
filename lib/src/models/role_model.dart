class Role {
  final String roleName;

  Role({required this.roleName});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleName: json['RoleName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RoleName': roleName,
    };
  }
}
