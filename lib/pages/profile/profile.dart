import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Usuário atual
  final User? user = FirebaseAuth.instance.currentUser;

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
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Perfil',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Exibir e-mail do usuário
                Text(
                  user != null ? "Logado como ${user!.email!}" : "Usuário não autenticado",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Botão para esquecer o e-mail cadastrado
                GestureDetector(
                  onTap: forgetAccountWithGoogle,
                  child: const Text(
                    "Esquecer e-mail cadastrado",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // Botão de logout (e-mail e senha)
                IconButton(
                  onPressed: signUserOutWithEmailAndPassword,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
