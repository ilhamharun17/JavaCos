import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/costume_model.dart';

class FavoriteData {
  static final List<Costume> items = [];

  static const String _key = 'favorite_costumes';

  // ===== LOAD FAVORITE FROM STORAGE =====
  static Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      items
        ..clear()
        ..addAll(decoded.map((e) => Costume.fromJson(e)));
    }
  }

  // ===== SAVE FAVORITE TO STORAGE =====
  static Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  // ===== CHECK =====
  static bool isFavorite(Costume costume) {
    return items.any((c) => c.id == costume.id);
  }

  // ===== TOGGLE =====
  static void toggle(Costume costume) {
    if (isFavorite(costume)) {
      items.removeWhere((c) => c.id == costume.id);
    } else {
      items.add(costume);
    }
    _saveFavorites();
  }
}
