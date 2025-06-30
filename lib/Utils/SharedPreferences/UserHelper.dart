import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static Future<String?> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('full_name');
  }
}
