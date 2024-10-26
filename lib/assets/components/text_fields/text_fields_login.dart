import 'package:flutter/material.dart';

class Textfields extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const Textfields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        //Controller para acessar as informações
        controller: controller,
        obscureText: obscureText,
        //Decoração do TextField
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          //Quando clicar muda cor da borda
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          //Cor de fundo do TextField
          fillColor: Colors.grey.shade200,
          filled: true,
          //Texto de dica dentro da caixa de texto
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}