import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomMenuItem extends StatelessWidget {
  final String title;
  final Widget destination;

  const CustomMenuItem({
    super.key,
    required this.title,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
