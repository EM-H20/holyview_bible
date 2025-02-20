import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleService {
  static Map<String, dynamic>? _bibleData;
  static List<String> bookList = [];
  static String selectedVersion = "개역개정"; // 기본 성경 버전

  /// 성경 버전별 파일 경로 매핑
  static const Map<String, String> bibleVersionPaths = {
    "개역개정": "assets/data/bible_NKRV.json",
    "개역개정-침례교회": "assets/data/bible_NKRV_Baptist.json",
  };

  /// 성경 데이터 로드
  static Future<void> loadBibleData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedVersion =
        prefs.getString("bibleVersion") ?? "개역개정"; // 저장된 성경 버전 불러오기

    String? filePath =
        bibleVersionPaths[selectedVersion]; // 선택한 버전에 맞는 파일 경로 가져오기
    if (filePath == null) return;

    final String jsonString = await rootBundle.loadString(filePath);
    _bibleData = json.decode(jsonString);
    bookList = _bibleData?.keys.toList() ?? [];
  }

  /// 특정 책과 장의 모든 절 가져오기
  static Map<String, String> getAllVerses(String book, int chapter) {
    if (_bibleData == null) {
      return {"오류": "데이터가 로드되지 않았습니다."};
    }
    Map<String, dynamic>? chapterData = _bibleData?[book]?[chapter.toString()];
    return chapterData?.map((key, value) =>
            MapEntry("$book $chapter:$key", value.toString())) ??
        {};
  }

  /// 선택된 책의 장 개수 반환
  static int getChapterCount(String book) {
    return _bibleData?[book]?.keys.length ?? 1;
  }

  /// 성경 버전 변경 및 저장
  static Future<void> changeBibleVersion(String newVersion) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("bibleVersion", newVersion);
    selectedVersion = newVersion;
    await loadBibleData(); // 새로운 성경 데이터 로드
  }
}
