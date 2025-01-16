import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  void signUserOutWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'authPage');
  }

  void forgetAccountWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'authPage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao deslogar: $e"),
        ),
      );
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
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
                      // Campo de CPF com máscara
                      TextField(
                        controller: cpfController,
                        decoration: const InputDecoration(labelText: 'CPF'),
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
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [MaskedInputFormatter('00/00/0000')],
                      ),
                      const SizedBox(height: 25),
                      // Botão de salvar
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF577096),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Salvar",
                              style: TextStyle(
                                  color: Color(0xFFA8BEE0), fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: signUserOutWithEmailAndPassword,
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey.shade100,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
