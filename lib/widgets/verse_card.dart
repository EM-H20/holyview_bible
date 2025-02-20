import 'package:flutter/material.dart';

class VerseCard extends StatelessWidget {
  final String verseText; // 성경 구절
  final String reference; // 성경 책, 장, 절 정보
  final String theme; // 테마 선택 (soft, dark, scenic)
  final double fontSize; // 폰트 사이즈
  final String backgroundImage; // 배경 이미지 경로
  final Color fontColor; // 폰트 색상
  final double backgroundOpacity; // 배경 이미지 투명도

  const VerseCard({
    super.key,
    required this.verseText,
    required this.reference,
    required this.theme,
    required this.fontSize,
    this.backgroundImage = '',
    this.fontColor = Colors.black,
    this.backgroundOpacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600, // 카드 너비
      height: 800, // 카드 높이
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: _getBackgroundGradient(theme), // 선택한 테마의 배경 그라데이션 적용
        borderRadius: BorderRadius.circular(25),
        image: backgroundImage.isNotEmpty
            ? DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black
                      .withValues(alpha: backgroundOpacity), // 반투명한 검정색 덧씌우기
                  BlendMode.darken,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50), // 부드러운 그림자
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 📌 성경 구절 정보 (예: "창세기 1:1")
          Text(
            reference,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: fontColor,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// 📌 성경 구절 텍스트
          Text(
            verseText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: fontColor,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),

          /// 📌 하단 장식 바
          const SizedBox(height: 30),
          Container(
            width: 80,
            height: 5,
            decoration: BoxDecoration(
              color: _getAccentColor(theme),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 테마별 배경 그라데이션 반환
  LinearGradient _getBackgroundGradient(String theme) {
    switch (theme) {
      case "dark":
        return LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "scenic":
        return LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        );
      default: // "soft"
        return LinearGradient(
          colors: [Colors.white, Colors.grey.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// 📌 테마별 강조색 반환
  Color _getAccentColor(String theme) {
    switch (theme) {
      case "dark":
        return Colors.white54;
      case "scenic":
        return Colors.white70;
      default: // "soft"
        return Colors.grey.shade700;
    }
  }
}
