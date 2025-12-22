import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddressData {
  static const _key = 'address_data';

  static Future<void> save(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(data);
    await prefs.setString(_key, jsonString);
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }
}
