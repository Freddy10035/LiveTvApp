class UserSignIn {
  final String userName;
  final String password;

  UserSignIn({ this.userName, this.password});

  factory UserSignIn.fromJson(Map<String, String> json) {
    return UserSignIn(
        userName: json["username"],
        password: json["password"]);
  }
}