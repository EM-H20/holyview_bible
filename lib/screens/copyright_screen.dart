import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CopyrightScreen extends StatelessWidget {
  const CopyrightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("저작권 출처"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "이 앱에서 사용된 리소스의\n저작권 정보:",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildCopyrightTileWithLink(
                context,
                "폰트",
                "이 Application에는 ㈜여기어때컴퍼니가 제공한 여기어때 잘난체가 적용되어 있습니다.",
                "https://noonnu.cc/font_page/115"),
            _buildCopyrightTileWithLink(
              context,
              "Instagram 아이콘",
              "Instagram 로고 아이콘 제작자: Freepik - Flaticon",
              "https://www.flaticon.com/kr/free-icon/instagram_1409946?term=%EC%9D%B8%EC%8A%A4%ED%83%80%EA%B7%B8%EB%9E%A8&page=1&position=3&origin=search&related_id=1409946",
            ),
            _buildCopyrightTileWithLink(
              context,
              "GitHub 아이콘",
              "고양이 아이콘 제작자: Dave Gandy - Flaticon",
              "https://www.flaticon.com/kr/free-icon/github-logo_25231",
            ),
            _buildCopyrightTileWithLink(
              context,
              "YouTube 아이콘",
              "유튜브 아이콘 제작자: NajmunNahar - Flaticon",
              "https://www.flaticon.com/kr/free-icon/youtube_3128307?term=%EC%9C%A0%ED%8A%9C%EB%B8%8C&page=1&position=1&origin=search&related_id=3128307",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyrightTileWithLink(
      BuildContext context, String title, String description, String url) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth, // 컨테이너 최대 너비로 설정
          child: InkWell(
            onTap: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                debugPrint("Could not launch $url");
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "자세히 보기",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
