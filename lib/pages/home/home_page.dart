import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Usuário
  final user = FirebaseAuth.instance.currentUser!;

  //Método de sign out do usuário
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text("Logado como " + user.email!),
      ),
    );
  }
}
