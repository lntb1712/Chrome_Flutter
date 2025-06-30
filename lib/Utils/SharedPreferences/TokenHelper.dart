import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
