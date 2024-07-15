class User {
  String? fullName;
  String? email;
  String? role;
  String? token;

  User(
      {required this.fullName,
      required this.email,
      required this.role,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"] ?? 'USER',
      token: json["token"],
    );
  }
}
