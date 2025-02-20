import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteService {
  static const String _favoritesKey = "favorite_verses";

  /// 📌 즐겨찾기 저장
  static Future<void> addFavorite(String verseKey, String verseText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    // 이미 존재하는지 확인
    bool isDuplicate = favorites.any((item) {
      final Map<String, dynamic> data = jsonDecode(item);
      return data["key"] == verseKey;
    });

    if (!isDuplicate) {
      String newFavorite = jsonEncode({"key": verseKey, "text": verseText});
      favorites.add(newFavorite);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// 📌 즐겨찾기 목록 불러오기 (오류 수정됨)
  static Future<List<Map<String, String>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.map((item) {
      final Map<String, dynamic> data = jsonDecode(item);
      return {
        "key": data["key"].toString(), // ✅ String 타입으로 변환
        "text": data["text"].toString() // ✅ String 타입으로 변환
      };
    }).toList();
  }

  /// 📌 즐겨찾기 삭제
  static Future<void> removeFavorite(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.removeWhere((item) {
      final Map<String, dynamic> data = jsonDecode(item);
      return data["key"] == verseKey;
    });

    await prefs.setStringList(_favoritesKey, favorites);
  }
}
