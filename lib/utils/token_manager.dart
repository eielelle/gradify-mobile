import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  Future<bool> saveToken(String? token) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString('auth_token', token);
    }
    
    return false;
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('auth_token');
  }
}