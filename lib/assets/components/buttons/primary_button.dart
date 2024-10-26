import 'package:flutter/material.dart';

class PrimaryButtonStyle {
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF577096),
    foregroundColor: const Color(0xFFA8BEE0),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 8, 
    shadowColor: Colors.black.withOpacity(0.4), 
  );
}
