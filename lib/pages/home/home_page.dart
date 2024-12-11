import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Usuário atual
  final user = FirebaseAuth.instance.currentUser!;

  // Fazer sign out do email e senha apenas
  void signUserOutWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
  }

  // Método para esquecer a conta Google cadastrada
  void forgetAccountWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Desconectar do Google, se estiver logado
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      // Fazer o sign out do Firebase
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao deslogar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Botão de logout (e-mail e senha)
          IconButton(
            onPressed: signUserOutWithEmailAndPassword,
            icon: const Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logado como " + user.email!),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: forgetAccountWithGoogle,
              child: Text(
                "Esquecer e-mail cadastrado",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline, // Adiciona sublinhado
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
