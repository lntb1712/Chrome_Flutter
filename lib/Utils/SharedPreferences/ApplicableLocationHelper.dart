import 'package:shared_preferences/shared_preferences.dart';

class ApplicableLocationHelper {
  static Future<String?> getApplicableLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('applicable_location');
  }
}
