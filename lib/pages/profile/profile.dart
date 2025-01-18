import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
    await _userDatabase.initializeUserProfile(user!.email!);

    final userProfile = await _userDatabase.getUserProfile();
    setState(() {
      nameController.text = userProfile['name'] ?? '';
      cpfController.text = userProfile['cpf'] ?? '';
      birthdateController.text = userProfile['birthdate'] ?? '';
    });
  }

  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'name': nameController.text,
      'cpf': cpfController.text.isEmpty ? null : cpfController.text,
      'birthdate':
          birthdateController.text.isEmpty ? null : birthdateController.text,
    });
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF2B3649),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Círculo para foto do usuário (Funcionalidade futura)
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0XFFEDE8E8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
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
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Campo de CPF com máscara
                      TextField(
                        controller: cpfController,
                        decoration: const InputDecoration(
                          labelText: 'CPF',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskedInputFormatter('000.000.000-00')
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Campo de data de nascimento com máscara
                      TextField(
                        controller: birthdateController,
                        decoration: const InputDecoration(
                          labelText: 'Data de Nascimento',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [MaskedInputFormatter('00/00/0000')],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Botão de salvar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF577096),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Color(0xFFA8BEE0), fontSize: 18),
                    ),
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
