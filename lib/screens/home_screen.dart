import 'package:holyview/screens/bible_screen.dart';
import 'package:holyview/screens/creed_screen.dart';
import 'package:holyview/screens/developer_screen.dart';
import 'package:holyview/screens/notification_screen.dart';
import 'package:holyview/screens/favorite_screen.dart';
import 'package:holyview/screens/fruit_of_the_spirit_screen.dart';
import 'package:holyview/screens/pray_screen.dart';
import 'package:holyview/screens/ten_commandments_screen.dart';
import 'package:holyview/widgets/custom_menu_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_img.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.4),
              BlendMode.modulate,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomMenuItem(
                        title: "안내사항", destination: const NotificationScreen()),
                    CustomMenuItem(
                        title: "즐겨찾기", destination: const FavoriteScreen()),
                    CustomMenuItem(
                        title: "십계명",
                        destination: const TenCommandmentsScreen()),
                    CustomMenuItem(
                        title: "주기도문", destination: const PrayScreen()),
                    CustomMenuItem(
                        title: "사도신경", destination: const CreedScreen()),
                    CustomMenuItem(
                        title: "성령의 열매",
                        destination: const FruitOfTheSpiritScreen()),
                    CustomMenuItem(
                        title: "성경보기", destination: const BibleScreen()),
                    // CustomMenuItem(title: "test", destination: Test()),
                    // CustomMenuItem(
                    //     title: "Self-Control", destination: Placeholder()),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'BIBLE',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact(); // 📌 클릭 시 중간정도 진동 발생
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeveloperScreen()),
                );
              },
              icon: const Icon(Icons.info_outlined, size: 45),
            ),
          ],
        ),
      ),
    );
  }
}
