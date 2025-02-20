import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildInfoCard extends StatelessWidget {
  final Widget leading; // IconData 대신 Widget으로 변경
  final String label;
  final String value;
  final String url;
  final VoidCallback onTap;

  const BuildInfoCard({
    super.key,
    required this.leading,
    required this.label,
    required this.value,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact(); // 📌 길게 눌렀을 때 진동
        Clipboard.setData(ClipboardData(text: value)); // 📌 길게 누르면 복사
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('복사됨: $value')), // 복사된 메시지
        );
      },
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                  width: 28, height: 28, child: leading), // Use leading widget
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
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
