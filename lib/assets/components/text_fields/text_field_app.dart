import 'package:flutter/material.dart';

class textFieldAppStyle {
  static final InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: const Color(0xFFEDE8E8),
    labelStyle: const TextStyle(color: Color(0xFF2B3649)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFEDE8E8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFEDE8E8)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFF577096)),
    ),
    prefixIconColor: const Color(0xFF577096),
  );
}