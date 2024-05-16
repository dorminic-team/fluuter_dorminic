import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Save userData to SharedPreferences
Future<void> saveUserData(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userData', jsonEncode(userData));
}

class UserData {
  // Get userData from SharedPreferences
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return {}; // Return an empty map if userData is not found
  }
}
