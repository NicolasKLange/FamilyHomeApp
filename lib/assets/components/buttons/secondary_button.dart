import 'package:flutter/material.dart';

class SecondaryButtonStyle {
  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    backgroundColor: const Color(0xFFA8BEE0),
    foregroundColor: const Color(0xFF2B3649),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    side: const BorderSide(color: Color(0xFF577096), width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 8, // Adiciona a sombra ao botão
    shadowColor: Colors.black.withOpacity(0.4), // Cor da sombra
  );
}