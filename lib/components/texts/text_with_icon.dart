import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  TextWithIcon({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
