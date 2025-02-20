import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 📌 진동 추가

class CustomDropdown<T> extends StatelessWidget {
  final T selectedValue; // 현재 선택된 값
  final List<T> items; // 드롭다운 리스트
  final void Function(T?) onChanged; // 값 변경 시 실행할 함수
  final String Function(T) displayText; // 표시할 텍스트 변환 함수
  final double width; // 드롭다운 너비

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.displayText,
    this.width = 140, // ✨ 기본 너비 설정 (조금 넓게 조정)
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✨ 기존 카드 배경색 적용
        borderRadius: BorderRadius.circular(15), // ✨ 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // ✨ 부드러운 그림자 효과
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<T>(
        value: selectedValue,
        underline: const SizedBox(), // 기본 밑줄 제거
        icon: const Icon(Icons.expand_more,
            color: Color(0xFF424874)), // 📌 아이콘 색상 변경
        dropdownColor: Theme.of(context).cardColor, // ✨ 드롭다운 배경색
        borderRadius: BorderRadius.circular(12), // ✨ 둥근 모서리
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF424874), // ✨ 기본 텍스트 색상
        ),
        items: items.map((T item) {
          return DropdownMenuItem(
            value: item,
            child: Text(displayText(item)), // 값 변환 함수 사용
          );
        }).toList(),
        onChanged: (value) {
          HapticFeedback.lightImpact(); // 📌 진동 추가
          onChanged(value); // 값 변경 실행
        },
      ),
    );
  }
}
