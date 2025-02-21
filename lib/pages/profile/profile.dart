import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../database/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseMethods _userDatabase = DatabaseMethods();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  Color avatarColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
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
                // Círculo com a inicial do nome do usuário
                GestureDetector(
                  onTap: _pickColor,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: avatarColor,
                    child: Text(
                      nameController.text.isNotEmpty
                          ? nameController.text[0].toUpperCase()
                          : '?', // Inicial do nome do usuário
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
                        onChanged: (value) {
                          setState(
                              () {}); // Atualiza a tela para refletir a nova inicial
                        },
                      ),
                      const SizedBox(height: 8),
                      // Campo de CPF
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
                      // Campo de data de nascimento
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

  Future<void> _initializeProfile() async {
    await _userDatabase.initializeUserProfile(user!.email!, userId);

    final userProfile = await _userDatabase.getUserProfile(userId);
    setState(() {
      nameController.text = userProfile['name'] ?? '';
      cpfController.text = userProfile['cpf'] ?? '';
      birthdateController.text = userProfile['birthdate'] ?? '';

      // Carregar a cor escolhida para o Firebase
      if (userProfile['avatarColor'] != null) {
        avatarColor = Color(int.parse(userProfile['avatarColor']));
      }
    });
  }

  //Editar dados de perfil
  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'name': nameController.text,
      'cpf': cpfController.text.isEmpty ? null : cpfController.text,
      'birthdate':
          birthdateController.text.isEmpty ? null : birthdateController.text,
      'avatarColor':
          avatarColor.value.toString(), // Salvar a cor como uma String
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  // Método para selecionar uma cor do avatar
  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Escolha uma cor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: avatarColor,
              onColorChanged: (Color color) {
                setState(() {
                  avatarColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}
