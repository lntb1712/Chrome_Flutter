import 'package:shared_preferences/shared_preferences.dart';

class UserNameHelper {
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
