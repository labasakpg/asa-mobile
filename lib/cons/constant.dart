// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constant {
  static String get baseAPI => dotenv.env['API_ENDPOINT'] as String;

  static String get accessToken => "access-token";
  static String get asPatient => "as-patient";
  static String get userName => "user-name";
  static String get isFirstTime => "first-time";
}
