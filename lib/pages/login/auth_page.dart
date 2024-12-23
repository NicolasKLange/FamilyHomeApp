import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Verifica se tem usuário no Firebase
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Usuário logado
          if(snapshot.hasData) {
            return HomePage();
          }
          // Usuário não logado
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}