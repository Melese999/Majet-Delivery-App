class UserModel {
  String? firstName;
  String? lastname;

  String? email;
  String? role;
  String? uid;

// receiving data
  UserModel({this.uid, this.email, this.role});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
    };
  }
}
