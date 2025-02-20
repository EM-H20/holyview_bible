import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // 공유 기능을 위한 패키지
import 'package:screenshot/screenshot.dart'; // 스크린샷 기능을 위한 패키지
import 'package:path_provider/path_provider.dart';

class ShareService {
  static final ScreenshotController screenshotController =
      ScreenshotController();
  static String backgroundImage = ''; // 배경 이미지 경로

  static Future<void> shareScreenshot({
    required BuildContext context,
    required String verseText,
    required String reference,
  }) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final imagePath = await screenshotController.captureAndSave(directory,
        fileName: 'verse_card.png');
    if (imagePath != null) {
      Share.shareXFiles([XFile(imagePath)], text: '$reference\n$verseText');
    }
  }

  static void setBackgroundImage(String imagePath) {
    backgroundImage = imagePath;
  }
}
