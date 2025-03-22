import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../assets/components/text_fields/text_fields_login.dart';

class ForgotPasswoardPage extends StatefulWidget {
  const ForgotPasswoardPage({super.key});

  @override
  State<ForgotPasswoardPage> createState() => _ForgotPasswoardPageState();
}

class _ForgotPasswoardPageState extends State<ForgotPasswoardPage> {
  final emailController = TextEditingController();

  //Coletar o email
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Mensagem de erro no topo da tela
  void showErrorMessage(String message) {
    Get.snackbar(
      'Erro de Login',
      'Este email não possui conta',
      backgroundColor: const Color(0xFF2B3649),
      colorText: const Color(0xFFEDE8E8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
    );
  }

  //Função para aleterar senha
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF577096),
              content: Text(
                'Link para aleterar senha enviado! Olhe seu email',
                style: TextStyle(
                  color: const Color(0xFFEDE8E8),
                  fontSize: 17,
                ),
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF577096),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Image.asset(
              'lib/assets/images/logoApp.png',
              height: 150,
              width: 150,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Digite seu email para aleterar a senha',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFEDE8E8),
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Textfields(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: passwordReset,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3649),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  "Alterar senha",
                  style: const TextStyle(
                    color: Color(0xFFA8BEE0),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Voltar para página de login',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEDE8E8),
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}
