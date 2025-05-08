class UserModel {
  final String uid;
  final String email;
  final String password;
  final String phone;
  final String role;
  final String userName;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    required this.phone,
    required this.userName,
    this.role = 'user', // Mặc định là user
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'userName': userName,
    };
  }
}
