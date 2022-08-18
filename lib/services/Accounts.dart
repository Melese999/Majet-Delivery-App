class Account {
  String? firstName;
  String? lastname;
  String? email;
  String? role;
  String? uid;

// receiving data
  Account({this.uid, this.email, this.role,this.firstName,this.lastname});
  factory Account.fromMap(map) {
    return Account(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      firstName:map['firstname'],
      lastname: map['lastname']
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'firstname':firstName,
      'lastname':lastname
    };
  }
}
