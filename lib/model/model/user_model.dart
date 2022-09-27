import 'package:sqflite/sqflite.dart';

class User {
  final String? userId;
  late String fullName;
  late String email;
  late String password;
  late String? imageUrl;

  User(
      {this.userId,
      required this.fullName,
      required this.email,
      required this.password,
      this.imageUrl});
  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      userId: jsonData['userId'] == null
          ? 'undefined'
          : jsonData['userId'].runtimeType == int
              ? jsonData['userId'].toString()
              : jsonData['userId'],
      fullName:
          jsonData['fullName'] == null ? 'undefined' : jsonData['fullName'],
      email: jsonData['email'] == null ? 'undefined' : jsonData['email'],
      password:
          jsonData['password'] == null ? 'undefined' : jsonData['password'],
      imageUrl:
          jsonData['imageUrl'] == null ? 'undefined' : jsonData['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'email': this.email,
      'password': this.password,
      'imageUrl': this.imageUrl == null ? 'undefined' : this.imageUrl
    };
  }
}
