import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holyview/widgets/show_fontsize_dialog.dart'; // showFontSizeDialog 임포트

class PrayScreen extends StatefulWidget {
  const PrayScreen({super.key});

  @override
  State<PrayScreen> createState() => _PrayScreenState();
}

class _PrayScreenState extends State<PrayScreen> {
  String selectedVersion = "traditionalKorean"; // 기본 버전
  Map<String, dynamic> prayerData = {};
  double fontSize = 20.0; // 기본 폰트 사이즈

  @override
  void initState() {
    super.initState();
    _loadSelectedVersion(); // 저장된 버전 불러오기
    _loadPrayerData();
    _loadFontSize();
  }

  /// 📌 주기도문 데이터 로드
  Future<void> _loadPrayerData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/prayers.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      prayerData = jsonData[selectedVersion];
    });
  }

  /// 📌 주기도문 버전 변경
  Future<void> _changePrayerVersion(String newVersion) async {
    await _saveSelectedVersion(newVersion); // 선택된 버전 저장
    setState(() {
      selectedVersion = newVersion;
      _loadPrayerData();
    });
  }

  /// 📌 폰트 사이즈 저장
  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("fontSize", size);
  }

  /// 📌 폰트 사이즈 불러오기
  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble("fontSize") ?? 20.0;
    });
  }

  /// 📌 선택된 버전 저장
  Future<void> _saveSelectedVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPrayerVersion', version);
  }

  /// 📌 선택된 버전 불러오기
  Future<void> _loadSelectedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVersion = prefs.getString('selectedPrayerVersion') ??
          "traditionalKorean"; // 기본값 설정
    });
  }

  /// 📌 화면 리로드
  void _reloadScreen() {
    setState(() {}); // 간단하게 setState를 호출하여 화면을 리로드
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "주기도문 (${prayerData['title'] ?? ''})",
          style: textTheme.titleMedium,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        actions: [
          /// 📌 주기도문 버전 선택 팝업 버튼 (스타일 적용)
          PopupMenuButton<String>(
            onSelected: (newVersion) {
              HapticFeedback.lightImpact(); // 약한 진동 추가
              _changePrayerVersion(newVersion);
            },
            icon: const Icon(
              Icons.view_list_rounded, // 아이콘 변경 가능
              color: Color(0xFF424874), // 아이콘 색상
            ),
            color: const Color(0xFFDCD6F7), // 팝업 배경색
            elevation: 3, // 그림자 효과
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
            ),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'traditionalKorean',
                child: Text(
                  '전통적인 한국어',
                  style: TextStyle(
                    color: Color(0xFF424874), // 텍스트 색상
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'modernKorean',
                child: Text(
                  '현대적인 한국어',
                  style: TextStyle(
                    color: Color(0xFF424874),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'traditionalEnglish',
                child: Text(
                  'Traditional English',
                  style: TextStyle(
                    color: Color(0xFF424874),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'modernEnglish',
                child: Text(
                  'Modern English',
                  style: TextStyle(
                    color: Color(0xFF424874),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          /// 📌 폰트 크기 조절 버튼
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              showFontSizeDialog(context, fontSize, (newFontSize) {
                _saveFontSize(newFontSize).then((_) {
                  setState(() {
                    fontSize = newFontSize;
                  });
                  _reloadScreen(); // 화면 리로드
                });
              });
            },
          ),
        ],
      ),

      /// 📌 주기도문 본문 UI
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              prayerData['content'] ?? '데이터 로딩 중...',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: fontSize, // 폰트 사이즈 적용
                height: 1.8,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                shadows: [
                  // 텍스트 그림자 효과
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.grey.withValues(alpha: 0.5),
                    offset: const Offset(1.0, 1.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // 가운데 정렬
            ),
          ),
        ),
      ),
    );
  }
}
