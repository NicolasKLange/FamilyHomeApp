import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const ButtonLogin({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        decoration: BoxDecoration(
            color: const Color(0xFF2B3649), borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
             color: Color(0xFFA8BEE0),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
