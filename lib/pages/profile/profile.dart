import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'databaseProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final UserDatabaseMethods _userDatabase = UserDatabaseMethods();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    // Inicializa o perfil do usuário com valores iniciais, se não existir
    await _userDatabase.initializeUserProfile(user!.email!);

    // Carrega os dados do usuário
    final userProfile = await _userDatabase.getUserProfile();
    setState(() {
      nameController.text = userProfile['name'] ?? '';
      cpfController.text = userProfile['cpf'] ?? '';
      birthdateController.text = userProfile['birthdate'] ?? '';
    });
  }

  Future<void> _updateProfile() async {
    await _userDatabase.updateUserProfile(
      nameController.text,
      cpfController.text.isEmpty ? null : cpfController.text,
      birthdateController.text.isEmpty ? null : birthdateController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
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
              children: [
                // Formulário de edição do perfil
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de nome
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                      ),
                      const SizedBox(height: 8),
                      // Campo de CPF
                      TextField(
                        controller: cpfController,
                        decoration: const InputDecoration(labelText: 'CPF'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      // Campo de data de nascimento
                      TextField(
                        controller: birthdateController,
                        decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 20),
                      // Botão de salvar
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Salvar Alterações",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
