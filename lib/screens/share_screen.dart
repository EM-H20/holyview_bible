import 'package:flutter/material.dart';
import 'package:holyview/widgets/verse_card.dart';
import 'package:holyview/service/share_service.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:convert';

class ShareScreen extends StatefulWidget {
  final String verseText;
  final String reference;
  final String theme;

  const ShareScreen({
    super.key,
    required this.verseText,
    required this.reference,
    required this.theme,
  });

  @override
  ShareScreenState createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen> {
  double fontSize = 24.0;
  Color fontColor = Colors.black;
  double backgroundOpacity = 0.2;

  Future<void> _selectBackgroundImage() async {
    HapticFeedback.lightImpact();
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
    final images = manifestMap.keys
        .where((String key) =>
            key.contains('assets/images/share_img') &&
            (key.endsWith('.png') || key.endsWith('.jpg')))
        .toList();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    ShareService.setBackgroundImage('');
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.replay_outlined,
                          size: 40, color: Colors.black),
                    ),
                  ),
                );
              } else {
                final imagePath = images[index - 1];
                return GestureDetector(
                  onTap: () {
                    ShareService.setBackgroundImage(imagePath);
                    setState(() {});
                  },
                  child: Image.asset(imagePath),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showFontSizeDialog(
    BuildContext context,
    double initialFontSize,
    Color initialFontColor,
    Function(double, Color) onFontSizeChanged,
  ) async {
    HapticFeedback.lightImpact();
    double tempFontSize = initialFontSize;
    Color tempFontColor = initialFontColor;
    double dialogOpacity = 1.0; // 초기 투명도 값 1.0으로 설정

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor:
                  Colors.white.withAlpha((dialogOpacity * 255).toInt()),
              title: const Text(
                "폰트 설정",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "미리보기",
                    style:
                        TextStyle(fontSize: tempFontSize, color: tempFontColor),
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
                      onFontSizeChanged(
                          tempFontSize, tempFontColor); // 실시간으로 폰트 크기 변경
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("폰트 색상"),
                      GestureDetector(
                        onTap: () async {
                          Color? pickedColor = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("색상 선택"),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: tempFontColor,
                                  availableColors: const [
                                    Colors.white,
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.yellow,
                                    Colors.orange,
                                    Colors.purple,
                                    Colors.brown,
                                    Colors.grey,
                                    Colors.black,
                                  ],
                                  onColorChanged: (color) {
                                    setState(() {
                                      tempFontColor = color;
                                      onFontSizeChanged(tempFontSize,
                                          tempFontColor); // 실시간으로 폰트 색상 변경
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop(tempFontColor);
                                  },
                                ),
                              ],
                            ),
                          );
                          if (pickedColor != null) {
                            setState(() {
                              tempFontColor = pickedColor;
                            });
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: tempFontColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("다이얼로그 투명도"),
                      Expanded(
                        child: Slider(
                          value: dialogOpacity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: (dialogOpacity * 100).round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              dialogOpacity = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
                TextButton(
                  child: const Text('확인'),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble("fontSize", tempFontSize);
                    await prefs.setInt("fontColor", tempFontColor.toARGB32());
                    // 저장 시 투명도 값도 저장

                    onFontSizeChanged(fontSize, fontColor);

                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
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

  Future<void> _showBackgroundOpacityDialog(
    BuildContext context,
    double initialOpacity,
    Function(double) onOpacityChanged,
  ) async {
    HapticFeedback.lightImpact();
    double tempOpacity = initialOpacity;

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // ✅ 새로운 context 사용
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "배경 이미지 투명도 조절",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "미리보기",
                    style: TextStyle(
                        fontSize: 24.0,
                        color:
                            Colors.black.withValues(alpha: 255 * tempOpacity)),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: tempOpacity,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: (tempOpacity * 100).round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        tempOpacity = value;
                        onOpacityChanged(tempOpacity); // 실시간으로 투명도 변경
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    HapticFeedback.lightImpact();
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
                    await prefs.setDouble(
                        "backgroundOpacity", tempOpacity); // ✅ 최종 저장
                    onOpacityChanged(tempOpacity); // ✅ 저장 시에만 콜백 호출

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("공유하기"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              HapticFeedback.lightImpact();
              switch (value) {
                case 'select_image':
                  _selectBackgroundImage();
                  break;
                case 'adjust_opacity':
                  await _showBackgroundOpacityDialog(
                    context,
                    backgroundOpacity,
                    (newOpacity) {
                      setState(() {
                        backgroundOpacity = newOpacity;
                      });
                    },
                  );
                  break;
                case 'adjust_font':
                  await _showFontSizeDialog(
                    context,
                    fontSize,
                    fontColor,
                    (newFontSize, newFontColor) {
                      setState(() {
                        fontSize = newFontSize;
                        fontColor = newFontColor;
                      });
                    },
                  );
                  break;
                case 'share':
                  ShareService.shareScreenshot(
                    context: context,
                    verseText: widget.verseText,
                    reference: widget.reference,
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'select_image',
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text('배경 이미지 선택'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'adjust_opacity',
                child: ListTile(
                  leading: Icon(Icons.opacity),
                  title: Text('배경 이미지 투명도 조절'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'adjust_font',
                child: ListTile(
                  leading: Icon(Icons.text_increase),
                  title: Text('폰트 색상 및 크기 조절'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('공유하기'),
                ),
              ),
            ],
            icon: const Icon(
              Icons.view_list_rounded,
              size: 27,
              color: Color(0xFF424874),
            ),
            color: const Color(0xFFDCD6F7),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: ShareService.screenshotController,
          child: VerseCard(
            verseText: widget.verseText,
            reference: widget.reference,
            theme: widget.theme,
            fontSize: fontSize,
            backgroundImage: ShareService.backgroundImage,
            fontColor: fontColor,
            backgroundOpacity: backgroundOpacity,
          ),
        ),
      ),
    );
  }
}
