import 'package:shared_preferences/shared_preferences.dart';

class MemoService {
  static const String _memoKey = 'memos';

  static Future<void> saveMemo(String memo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> memos = prefs.getStringList(_memoKey) ?? [];
    memos.add(memo);
    await prefs.setStringList(_memoKey, memos);
  }

  static Future<List<String>> loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_memoKey) ?? [];
  }

  static Future<void> updateMemo(int index, String updatedMemo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> memos = prefs.getStringList(_memoKey) ?? [];
    if (index >= 0 && index < memos.length) {
      memos[index] = updatedMemo;
      await prefs.setStringList(_memoKey, memos);
    }
  }

  static Future<void> deleteMemo(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> memos = prefs.getStringList(_memoKey) ?? [];
    if (index >= 0 && index < memos.length) {
      memos.removeAt(index);
      await prefs.setStringList(_memoKey, memos);
    }
  }
}
