class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? userName;
  String? role;
  bool? isBlocked;

  UserModel({
    this.uid,
    this.email,
    this.phone,
    this.userName,
    this.role = 'user',
    this.isBlocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'userName': userName,
      'role': role ?? 'user',
      'isBlocked': isBlocked ?? false,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserModel();
    return UserModel(
      uid: map['uid'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      userName: map['userName'] as String?,
      role: map['role'] as String? ?? 'user',
      isBlocked: map['isBlocked'] as bool? ?? false,
    );
  }
}