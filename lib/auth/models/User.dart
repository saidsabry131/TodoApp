class User {
  final String email;
  final String password;

  User(this.email, this.password);

  User.fromMap(Map<String, dynamic> map)
      : email = map['email'] as String,
        password = map['password'] as String;

  String get getEmail => email;
  String get getPassword => password;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
