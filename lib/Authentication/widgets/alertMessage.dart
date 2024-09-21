// lib/widgets/alert_message.dart
import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final double width;

  const AlertMessage({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}