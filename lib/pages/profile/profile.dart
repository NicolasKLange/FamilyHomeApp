import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2B3649), width: 2),
            ),
            child: Center(
              child: Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B3649),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: const Color(0XFFEDE8E8),
                    border:
                        Border.all(color: const Color(0xFF2B3649), width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF577096),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(3, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // Círculo com a inicial do nome do usuário
                      Center(
                        child: GestureDetector(
                          onTap: _pickColor,
                          child: Container(
                            //sombra no avatar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF577096),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: avatarColor,
                              child: Text(
                                nameController.text.isNotEmpty
                                    ? nameController.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Campo de nome
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color(
                                (0xFF2B3649),
                              ),
                            ),
                            hintText: 'Digite seu nome',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Campo de CPF
                      Row(
                        children: [
                          // Campo de data de nascimento
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                controller: birthdateController,
                                decoration: const InputDecoration(
                            labelText: 'Data de nascimento',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color(
                                (0xFF2B3649),
                              ),
                            ),
                            hintText: 'DD/MM/AAAA',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskedInputFormatter('00/00/0000'),
                                ],
                                onChanged: validateDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // Botão de salvar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF577096),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(1, 5),
                      ),
                    ],
                  ),
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

  void validateDate(String value) {
    if (value.length == 10) {
      try {
        DateFormat format = DateFormat('dd/MM/yyyy');
        DateTime date = format.parseStrict(value);

        if (date.year > 2030) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ano não pode ser maior que 2030!'),
            ),
          );
          birthdateController.clear();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data inválida!'),
          ),
        );
        birthdateController.clear();
      }
    }
  }

  Future<void> _initializeProfile() async {
    await _userDatabase.initializeUserProfile(user!.email!, userId);

    final userProfile = await _userDatabase.getUserProfile(userId);
    setState(() {
      nameController.text = userProfile['name'] ?? '';
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
