import 'package:anugerah_mobile/models/user.dart';

class AuthData {
  String? authorization;
  User? user;
  DateTime? exp;

  AuthData({
    this.authorization,
    this.user,
    this.exp,
  });

  @override
  String toString() {
    return {
      "authorization": authorization,
      "user": user?.toJson(),
      "exp": exp,
    }.toString();
  }
}
