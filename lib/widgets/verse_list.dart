import 'package:holyview/widgets/verse_item.dart';
import 'package:flutter/material.dart';

class VerseList extends StatelessWidget {
  final Map<String, String> verses;
  final double fontSize;
  final Function(String, String) onVerseLongPress; // 📌 길게 누를 때 실행할 콜백

  const VerseList({
    super.key,
    required this.verses,
    required this.fontSize,
    required this.onVerseLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          String key = verses.keys.elementAt(index);
          return VerseItem(
            verseNumber: key.split(' ').last,
            verseText: verses[key]!,
            fontSize: fontSize,
            onLongPress: () => onVerseLongPress(key, verses[key]!),
          );
        },
      ),
    );
  }
}
