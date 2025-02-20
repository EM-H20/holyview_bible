import 'package:holyview/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // 전체 배경색 설정
        fontFamily: 'Jalnan2', // 글꼴 설정
        scaffoldBackgroundColor: Color(0xFFF4EEFF),

        // AppBar 테마 설정
        appBarTheme: AppBarTheme(
          color: Color(0xFFA6B1E1), // AppBar 배경색
          titleTextStyle: TextStyle(
            color: Color(0xFF424874), // AppBar 제목 색상
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF424874)), // AppBar 아이콘 색상
        ),

        // 기본 텍스트 테마 설정
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF424874).withValues(alpha: 0.5),
            fontSize: 45,
            fontWeight: FontWeight.normal,
          ), // 기본 텍스트 색상
          bodyMedium: TextStyle(color: Color(0xFF424874)),
        ),

        // 버튼 테마 설정
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFDCD6F7), // 버튼 배경색
          textTheme: ButtonTextTheme.primary,
        ),

        // ElevatedButton 테마 설정
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFDCD6F7), // 버튼 배경색
            foregroundColor: Color(0xFF424874), // 버튼 텍스트 색상
          ),
        ),

        // 카드 배경색 설정
        cardColor: Color(0xFFE3DFFD),

        // 아이콘 색상 설정
        iconTheme: IconThemeData(color: Color(0xFF424874)),
      ),
      home: HomeScreen(), // 메인 화면 설정
    );
  }
}
