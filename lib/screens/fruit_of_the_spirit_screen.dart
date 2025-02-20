import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard, HapticFeedback
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences

class FruitOfTheSpiritScreen extends StatefulWidget {
  const FruitOfTheSpiritScreen({super.key});

  @override
  State<FruitOfTheSpiritScreen> createState() => _FruitOfTheSpiritScreenState();
}

class _FruitOfTheSpiritScreenState extends State<FruitOfTheSpiritScreen> {
  bool isKorean = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  // 언어 설정을 SharedPreferences에서 불러오기
  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isKorean = prefs.getBool('isKorean') ?? true; // 기본값은 한국어
    });
  }

  // 언어 설정을 SharedPreferences에 저장하기
  Future<void> _saveLanguagePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isKorean', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isKorean ? "성령의 열매" : "Fruit of the Spirit", // 앱바 제목에 isKorean 적용
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Container(
            width: 51.5,
            height: 51.5,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.translate,
                color: Color(0xFF424874), //AppBar 아이콘 색상
              ),
              color: const Color(0xFFDCD6F7), // 배경색
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onSelected: (String value) {
                HapticFeedback.lightImpact(); // 📌 팝업 메뉴 선택 시 약한 진동
                setState(() {
                  isKorean = value == "korean";
                });
                _saveLanguagePreference(isKorean); // 설정 저장
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "korean",
                    child: Center(
                      child: Text(
                        "한국어",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424874), // 텍스트 색상
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "english",
                    child: Center(
                      child: Text(
                        "English",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424874), // 텍스트 색상
                        ),
                      ),
                    ),
                  ),
                ];
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKorean ? "갈라디아서 5:22-23" : "Galatians 5:22-23",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isKorean
                  ? "오직 성령의 열매는 사랑과 희락과 화평과 오래 참음과 자비와 양선과 충성과 온유와 절제니 이같은 것을 금지할 법이 없느니라"
                  : "But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness, and self-control. Against such things there is no law.",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            const SizedBox(height: 20),
            _buildFruitTile(
              context,
              isKorean ? "사랑" : "Love",
              isKorean
                  ? "사랑은 오래 참고 사랑은 온유하며 시기하지 아니하며 자랑하지 아니하며 교만하지 아니하며 (고린도전서 13:4)"
                  : "Love is patient, love is kind. It does not envy, it does not boast, it is not proud. (1 Corinthians 13:4)",
              Icons.favorite,
            ),
            _buildFruitTile(
              context,
              isKorean ? "희락" : "Joy",
              isKorean
                  ? "항상 기뻐하라 쉬지 말고 기도하라 범사에 감사하라 이것이 그리스도 예수 안에서 너희를 향하신 하나님의 뜻이니라 (데살로니가전서 5:16-18)"
                  : "Rejoice in the Lord always. I will say it again: Rejoice! (Philippians 4:4)",
              Icons.sentiment_satisfied,
            ),
            _buildFruitTile(
              context,
              isKorean ? "화평" : "Peace",
              isKorean
                  ? "화평하게 하는 자들은 복이 있나니 그들이 하나님의 아들이라 일컬음을 받을 것임이요 (마태복음 5:9)"
                  : "Blessed are the peacemakers, for they will be called children of God. (Matthew 5:9)",
              Icons.local_florist,
            ),
            _buildFruitTile(
              context,
              isKorean ? "오래 참음" : "Patience",
              isKorean
                  ? "모든 겸손과 온유로 하고 오래 참음으로 사랑 가운데서 서로 용납하고 (에베소서 4:2)"
                  : "Be completely humble and gentle; be patient, bearing with one another in love. (Ephesians 4:2)",
              Icons.timer,
            ),
            _buildFruitTile(
              context,
              isKorean ? "자비" : "Kindness",
              isKorean
                  ? "그러므로 너희는 하나님이 택하사 거룩하고 사랑 받는 자처럼 긍휼과 자비와 겸손과 온유와 오래 참음을 옷 입고 (골로새서 3:12)"
                  : "Therefore, as God’s chosen people, holy and dearly loved, clothe yourselves with compassion, kindness, humility, gentleness, and patience. (Colossians 3:12)",
              Icons.volunteer_activism,
            ),
            _buildFruitTile(
              context,
              isKorean ? "양선" : "Goodness",
              isKorean
                  ? "이같이 너희 빛이 사람 앞에 비치게 하여 그들로 너희 착한 행실을 보고 하늘에 계신 너희 아버지께 영광을 돌리게 하라 (마태복음 5:16)"
                  : "Let your light shine before others, that they may see your good deeds and glorify your Father in heaven. (Matthew 5:16)",
              Icons.verified_user,
            ),
            _buildFruitTile(
              context,
              isKorean ? "충성" : "Faithfulness",
              isKorean
                  ? "지극히 작은 것에 충성된 자는 큰 것에도 충성되고 지극히 작은 것에 불의한 자는 큰 것에도 불의하니라 (누가복음 16:10)"
                  : "The one who is faithful in a very little is also faithful in much, and the one who is dishonest in a very little is also dishonest in much. (Luke 16:10)",
              Icons.security,
            ),
            _buildFruitTile(
              context,
              isKorean ? "온유" : "Gentleness",
              isKorean
                  ? "나는 마음이 온유하고 겸손하니 나의 멍에를 메고 내게 배우라 그리하면 너희 마음이 쉼을 얻으리니 (마태복음 11:29)"
                  : "Take my yoke upon you and learn from me, for I am gentle and humble in heart, and you will find rest for your souls. (Matthew 11:29)",
              Icons.nature_people,
            ),
            _buildFruitTile(
              context,
              isKorean ? "절제" : "Self-Control",
              isKorean
                  ? "그러므로 너희 몸으로 죄의 욕심을 좇아 죄에게 내주지 말라 (로마서 6:12)"
                  : "Therefore do not let sin reign in your mortal body so that you obey its evil desires. (Romans 6:12)",
              Icons.fitness_center,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _buildFruitTile(
      BuildContext context, String title, String description, IconData icon) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact(); // 📌 길게 눌렀을 때 진동
        Clipboard.setData(ClipboardData(text: description));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$description 복사됨')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon,
                  size: 32,
                  color: Theme.of(context).iconTheme.color), // 테마 색상 적용
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
