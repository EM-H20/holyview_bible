// ignore_for_file: use_build_context_synchronously

import 'package:holyview/screens/share_screen.dart';
import 'package:holyview/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:holyview/service/bible_service.dart';
import 'package:holyview/widgets/bible_header.dart';
import 'package:holyview/service/favorite_service.dart'; // ✅ 추가
import 'package:holyview/widgets/show_fontsize_dialog.dart'; // ✅ 사용하지 않던 import 다시 사용
import 'package:holyview/widgets/navigation_buttons.dart';
import 'package:holyview/widgets/verse_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' as flutter_services; // ✅ 진동 기능 추가

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  String selectedBook = "창세기";
  int selectedChapter = 1;
  Map<String, String> verses = {};
  List<String> bookList = [];
  double fontSize = 16.0; // ✅ 폰트 크기 변수 유지
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _loadFontSize(),
      _loadLastPosition(),
      _loadBibleData(),
    ]);
    _loadVerses();
    setState(() => isLoading = false);
  }

  Future<void> _loadBibleData() async {
    await BibleService.loadBibleData();
    bookList = BibleService.bookList;
  }

  Future<void> _saveLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastBook', selectedBook);
    await prefs.setInt('lastChapter', selectedChapter);
  }

  Future<void> _loadLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    selectedBook = prefs.getString('lastBook') ?? "창세기";
    selectedChapter = prefs.getInt('lastChapter') ?? 1;
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("fontSize", size);
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    fontSize = prefs.getDouble("fontSize") ?? 16.0;
  }

  void _loadVerses() {
    setState(() {
      verses = BibleService.getAllVerses(selectedBook, selectedChapter);
    });
    _saveLastPosition();
  }

  void _onVersionChanged() {
    _initializeData();
  }

  void _goToNextChapter() {
    int maxChapter = BibleService.getChapterCount(selectedBook);
    if (selectedChapter < maxChapter) {
      setState(() {
        selectedChapter++;
        _loadVerses();
      });
    } else {
      _showMessage("마지막 장입니다.");
    }
  }

  void _goToPreviousChapter() {
    if (selectedChapter > 1) {
      setState(() {
        selectedChapter--;
        _loadVerses();
      });
    } else {
      _showMessage("첫 번째 장입니다.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onVerseLongPress(String verseKey, String verseText) {
    flutter_services.HapticFeedback.mediumImpact(); // 📌 진동 추가

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("즐겨찾기에 추가", style: TextStyle(fontSize: 20)),
            onTap: () async {
              flutter_services.HapticFeedback.lightImpact();
              await FavoriteService.addFavorite(
                  verseKey, verseText); // ✅ 즐겨찾기 추가
              Navigator.pop(context);
              _showMessage("$verseKey이(가) 즐겨찾기에 추가되었습니다.");
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("공유하기", style: TextStyle(fontSize: 20)),
            onTap: () {
              flutter_services.HapticFeedback.lightImpact();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShareScreen(
                    verseText: verseText,
                    reference: verseKey,
                    theme: "soft",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("메모 추가", style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context);
              _showMessage("메모 기능 구현 예정");
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "성경",
        onVersionChanged: _onVersionChanged,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// 📌 상단 설정 UI
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// 📌 성경 선택
                      CustomDropdown<String>(
                        selectedValue: selectedBook,
                        items: bookList,
                        displayText: (book) => book,
                        onChanged: (value) {
                          setState(() {
                            selectedBook = value!;
                            selectedChapter = 1;
                            _loadVerses();
                          });
                        },
                      ),

                      /// 📌 장 선택 (재사용 위젯 적용)
                      CustomDropdown<int>(
                        selectedValue: selectedChapter,
                        items: List.generate(
                            BibleService.getChapterCount(selectedBook),
                            (index) => index + 1),
                        displayText: (chapter) => "$chapter장",
                        onChanged: (value) {
                          setState(() {
                            selectedChapter = value!;
                            _loadVerses();
                          });
                        },
                      ),

                      /// 📌 글꼴 크기 조절 (✅ 다시 추가됨)
                      Container(
                        width: 51.5,
                        height: 51.5,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).cardColor, // 📌 배경색 적용 (일관성 유지)
                          borderRadius: BorderRadius.circular(12), // 📌 둥근 모서리
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha(50), // ✨ 부드러운 그림자 효과
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.text_increase,
                              color: Color(0xFF424874)), // 아이콘 색상 통일
                          onPressed: () {
                            flutter_services.HapticFeedback
                                .lightImpact(); // 📌 진동 추가
                            showFontSizeDialog(context, fontSize,
                                (newFontSize) {
                              setState(() {
                                fontSize = newFontSize;
                              });
                              _saveFontSize(newFontSize); // ✅ 폰트 크기 저장 추가
                              _loadVerses();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),

                /// 📌 말씀 리스트
                VerseList(
                  verses: verses,
                  fontSize: fontSize,
                  onVerseLongPress: _onVerseLongPress,
                ),

                /// 📌 이전/다음 장 이동 버튼
                NavigationButtons(
                  onPrevious: _goToPreviousChapter,
                  onNext: _goToNextChapter,
                  isFirst: selectedChapter == 1,
                  isLast: selectedChapter ==
                      BibleService.getChapterCount(selectedBook),
                ),
              ],
            ),
    );
  }
}
