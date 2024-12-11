import 'package:flutter/material.dart';

class Textfields extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const Textfields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<Textfields> createState() => _TextfieldsState();
}

class _TextfieldsState extends State<Textfields> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const  Color(0xFF2B3649).withOpacity(0.5), // Cor da sombra (preto)
              blurRadius: 10.0, // Suavidade da sombra
              offset: const Offset(2, 7), // Deslocamento horizontal e vertical
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent), // Sem cor de borda
              borderRadius: BorderRadius.circular(15.0)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400), // Borda ao focar
              borderRadius: BorderRadius.circular(15.0), // Arredondamento
            ),
            fillColor: const Color(0xFFA8BEE0),
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFF577096)),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF577096),
                    ),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
