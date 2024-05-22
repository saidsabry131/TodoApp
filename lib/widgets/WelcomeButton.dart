import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
