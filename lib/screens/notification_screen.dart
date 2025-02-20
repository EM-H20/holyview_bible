import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("안내사항"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: "앱 이용 안내",
                content: [
                  _buildNotificationPoint(context,
                      "이 앱은 건전한 신앙생활을 지원하기 위해 제작되었습니다. 따라서, 다음과 같은 단체는 절대 용납하지 않습니다."),
                  const SizedBox(height: 10),
                  _buildNotificationPoint(context, "1. 세계복음화전도협회 (다락방, 류광수)"),
                  _buildNotificationPoint(context, "2. 신천지 예수교 장막성전 (신천지교회)"),
                  _buildNotificationPoint(context, "3. 세계 평화통일 가정연합 (통일교)"),
                  _buildNotificationPoint(context, "4. 여호와의 증인"),
                  _buildNotificationPoint(context, "5. 예수 그리스도 후기 성도 교회 (몰몬교)"),
                  _buildNotificationPoint(
                      context, "6. 하나님의 교회 세계복음선교협회 (안상홍증인회)"),
                  _buildNotificationPoint(context,
                      "7. 구원파 (구원파는 침례교라는 간판을 사용한다.\nex) 기독교 복음 침례회 등이 있다.)\n『오직』 \"기독교 한국 침례회\"만이 정식으로 등록된 교회이다.)"),
                  _buildNotificationPoint(context, "8. 기독교복음선교회 (JMS)"),
                  _buildNotificationPoint(context, "9. 제칠일안식일예수재림교회 (안식교)"),
                  _buildNotificationPoint(
                      context, "10. 전능하신 하나님의 교회 (전능신교 및 동방번개파)"),
                  const SizedBox(height: 10),
                  _buildNotificationPoint(
                      context, "등 정식절차가 아닌 비정식 절차로 설립된 교회는 본 앱에서 지원하지 않습니다."),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: "번역 관련 고지",
                content: [
                  _buildNotificationPoint(context,
                      "영어 버전 성경 구절은 참고용으로 제공되며, 원문의 의미와 약간의 차이가 있을 수 있습니다. 정확한 의미 전달을 위해 가능하면 원문 또는 공인된 번역본을 참고하시기 바랍니다."),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: "면책 조항",
                content: [
                  _buildNotificationPoint(context,
                      "이 앱은 정보 제공 목적으로만 제공되며, 어떠한 법적 책임도 지지 않습니다. 앱 사용으로 인해 발생하는 모든 결과에 대한 책임은 사용자에게 있습니다."),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            size: 26,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "안녕하세요! 저희 앱을 이용해 주셔서 감사합니다. 본 앱의 이용에 앞서 다음과 같은 안내사항을 확인하시기 바랍니다.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> content}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
          const SizedBox(height: 10),
          ...content,
        ],
      ),
    );
  }

  Widget _buildNotificationPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.cancel, color: Colors.red),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
