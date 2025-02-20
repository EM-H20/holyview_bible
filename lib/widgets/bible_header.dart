import 'package:holyview/service/bible_service.dart'; // BibleService 임포트
import 'package:flutter/material.dart'; // Flutter Material 디자인 임포트
import 'package:flutter/services.dart'; // 📌 HapticFeedback 임포트

class Header extends StatefulWidget implements PreferredSizeWidget {
  final String title; // AppBar 제목
  final Function onVersionChanged; // 버전 변경 후 화면 새로 고침 콜백

  const Header({
    super.key,
    required this.title,
    required this.onVersionChanged,
  });

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  String selectedVersion = BibleService.selectedVersion; // 현재 선택된 성경 버전

  @override
  void initState() {
    super.initState();
    _loadSelectedVersion(); // 선택된 성경 버전 로드
  }

  /// 📌 선택된 성경 버전 불러오기
  Future<void> _loadSelectedVersion() async {
    await BibleService.loadBibleData();
    setState(() {
      selectedVersion = BibleService.selectedVersion;
    });
  }

  /// 📌 성경 버전 변경 (진동 추가)
  Future<void> _changeBibleVersion(String newVersion) async {
    HapticFeedback.lightImpact(); // 📌 성경 버전 선택 시 진동 발생
    await BibleService.changeBibleVersion(newVersion);
    setState(() {
      selectedVersion = newVersion;
    });
    widget.onVersionChanged(); // 📌 부모 위젯에 화면 새로 고침 콜백 호출
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "${widget.title} ($selectedVersion)",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      iconTheme: Theme.of(context).appBarTheme.iconTheme,
      actions: [
        PopupMenuButton<String>(
          onSelected: _changeBibleVersion, // 📌 성경 버전 변경 함수 호출 (진동 포함)
          itemBuilder: (context) => BibleService.bibleVersionPaths.keys
              .map((version) => PopupMenuItem(
                    value: version,
                    child: Center(
                      child: Text(
                        version,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424874),
                        ),
                      ),
                    ),
                  ))
              .toList(),
          icon: const Icon(
            Icons.menu_book,
            color: Color(0xFF424874),
          ),
          color: const Color(0xFFDCD6F7),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
