class RegisterRequest {
  String name;
  String email;
  String password;
  String phoneNumber;

  RegisterRequest(
      {required this.name,
      required this.email,
      required this.password,
      required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
