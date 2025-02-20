import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 진동 추가

class VerseItem extends StatelessWidget {
  final String verseNumber;
  final String verseText;
  final double fontSize;
  final VoidCallback onLongPress; // 길게 누를 때 실행할 함수

  const VerseItem({
    super.key,
    required this.verseNumber,
    required this.verseText,
    required this.fontSize,
    required this.onLongPress, // 📌 재사용을 위해 외부에서 이벤트 정의 가능
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact(); // 📌 길게 누를 때 진동
        onLongPress(); // 📌 외부에서 정의한 이벤트 실행
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 수평 정렬
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 1, vertical: 1.6), //수평정렬
              child: Text(
                verseNumber, // 장:절
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.start, // 왼쪽 정렬
              ),
            ),
            SizedBox(width: 15), // 장:절과 내용 사이 간격
            Expanded(
              child: Text(
                verseText, // 성경 내용
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.6,
                ),
                textAlign: TextAlign.start, // 왼쪽 정렬
              ),
            ),
          ],
        ),
      ),
    );
  }
}
