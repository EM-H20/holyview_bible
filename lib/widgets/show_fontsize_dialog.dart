import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showFontSizeDialog(
  BuildContext context,
  double initialFontSize,
  Function(double) onFontSizeChanged,
) async {
  double tempFontSize = initialFontSize;

  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      // ✅ 새로운 context 사용
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("폰트 사이즈 조절"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "미리보기",
                  style: TextStyle(fontSize: tempFontSize),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: tempFontSize,
                  min: 14.0,
                  max: 30.0,
                  divisions: 16,
                  label: tempFontSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      tempFontSize = value;
                    });
                    onFontSizeChanged(value); // ✅ 실시간 반영
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onFontSizeChanged(initialFontSize); // ✅ 원래 크기로 복원
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(); // ✅ `mounted` 체크 후 닫기
                  }
                },
              ),
              TextButton(
                child: const Text('저장'),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setDouble("fontSize", tempFontSize); // ✅ 최종 저장

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(); // ✅ `mounted` 체크 후 닫기
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
