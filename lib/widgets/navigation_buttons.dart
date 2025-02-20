import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 📌 진동 기능 추가

class NavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isFirst;
  final bool isLast;

  const NavigationButtons({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.isFirst,
    required this.isLast,
  });

  /// 📌 메시지를 디자인하여 보여주는 함수 (진동 추가)
  void _showMessage(BuildContext context, String message) {
    HapticFeedback.lightImpact(); // 📌 약한 진동 추가
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: theme.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 📌 버튼 간격 조정
        children: [
          /// 📌 이전 버튼 (왼쪽 정렬)
          Padding(
            padding: const EdgeInsets.only(left: 20), // 좌측 여백 추가
            child: TextButton(
              onPressed: isFirst
                  ? () => _showMessage(context, "첫 번째 페이지입니다.")
                  : () {
                      HapticFeedback.lightImpact(); // 📌 이전 버튼 클릭 시 진동 추가
                      onPrevious();
                    },
              child: const Text("이전", style: TextStyle(fontSize: 18)),
            ),
          ),

          /// 📌 다음 버튼 (오른쪽 정렬)
          Padding(
            padding: const EdgeInsets.only(right: 20), // 우측 여백 추가
            child: TextButton(
              onPressed: isLast
                  ? () => _showMessage(context, "마지막 페이지입니다.")
                  : () {
                      HapticFeedback.lightImpact(); // 📌 다음 버튼 클릭 시 진동 추가
                      onNext();
                    },
              child: const Text("다음", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
