class UserModel {
  final String fullName;
  final String email;
  final String userName;
  final String password;

  UserModel({this.fullName, this.email, this.userName, this.password});

  factory UserModel.fromJson(Map<String, String> json) {
    return UserModel(
      fullName: json['fullname'],
      email: json['email'],
      userName: json['username'],
      password: json['password'],
    );
  }
}
