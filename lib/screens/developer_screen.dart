import 'package:holyview/widgets/build_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holyview/screens/copyright_screen.dart'; // Import CopyrightScreen
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  /// 📌 URL을 여는 함수
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // launchUrl로 변경
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("개발자 정보"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 📌 프로필 이미지
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage("assets/images/profile.png"), // 프로필 이미지 추가
            ),
            const SizedBox(height: 16),

            /// 📌 개발자 이름
            Text(
              "엘리페어 (EM-H20)", // 개발자 이름
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            /// 📌 개발자 직업 / 역할
            Text(
              "Flutter Developer | Mobile & Web App Engineer",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 20),

            /// 📌 정보 카드 (이메일, GitHub, 블로그)
            BuildInfoCard(
              leading: Icon(Icons.email,
                  color: Theme.of(context).primaryColor, size: 28),
              label: "Business Email",
              value: "elipair0106@gmail.com",
              url: "mailto:elipair0106@gmail.com",
              onTap: () {
                _launchURL("mailto:elipair0106@gmail.com"); // URL 실행 추가
                HapticFeedback.lightImpact(); // 클릭 시 진동 추가
              },
            ),
            BuildInfoCard(
              leading: Image.asset(
                'assets/images/instagram_logo.png', // 인스타그램 로고 이미지 경로
                width: 28,
                height: 28,
              ),
              label: "Instagram",
              value: "@e_m_hong",
              url: "https://www.instagram.com/e_m_hong/",
              onTap: () {
                _launchURL("https://www.instagram.com/e_m_hong/"); // URL 실행 추가
                HapticFeedback.lightImpact(); // 클릭 시 진동 추가
              },
            ),
            BuildInfoCard(
              leading: Image.asset(
                'assets/images/github_logo.png', // 깃허브 로고 이미지 경로
                width: 28,
                height: 28,
              ),
              label: "GitHub",
              value: "github.com/EM-H20",
              url: "https://github.com/EM-H20",
              onTap: () {
                _launchURL("https://github.com/EM-H20"); // URL 실행 추가
                HapticFeedback.lightImpact(); // 클릭 시 진동 추가
              },
            ),
            BuildInfoCard(
              leading: Image.asset(
                'assets/images/youtube_logo.png', // 유튜브 로고 이미지 경로
                width: 28,
                height: 28,
              ),
              label: "Elipair YouTube",
              value: "youtube.com/@elipair-kr1",
              url: "https://www.youtube.com/@elipair-kr1",
              onTap: () {
                _launchURL("https://www.youtube.com/@elipair-kr1"); // URL 실행 추가
                HapticFeedback.lightImpact(); // 클릭 시 진동 추가
              },
            ),
            BuildInfoCard(
              leading: Icon(Icons.copyright,
                  color: Theme.of(context).primaryColor, size: 28),
              label: "저작권 출처",
              value: "앱에서 사용된 리소스의 출처 정보",
              url: "", // Remove URL
              onTap: () {
                HapticFeedback.lightImpact(); // 클릭 시 진동 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CopyrightScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
