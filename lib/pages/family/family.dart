import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import '../../database/database.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  Stream? todoStream;
  final user = FirebaseAuth.instance.currentUser!;
  //final DatabaseMethods _databaseMethods = DatabaseMethods();
  final TextEditingController familyNameController = TextEditingController();
  List<String> selectedUsers = [];
  // Define a categoria

  @override
  void initState() {
    super.initState();
  }

  Widget familyMembers() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2B3649),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: familyNameController,
                              decoration: const InputDecoration(
                                hintText: 'Nome família',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color(0XFF707275),
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFF2B3649),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Ícone de adicionar produto
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF2B3649),
                                ),
                                onPressed: openBoxMembers,
                              ),
                              // Três pontinhos
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors
                                        .transparent, // Fundo transparente
                                    builder: (context) {
                                      return Container(
                                        height: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o menu inferior
                                                },
                                              ),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                      "Confirmar Exclusão",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF2B3649),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFFEDE8E8),
                                                    content: const Text(
                                                      "Você realmente deseja excluir esta familia?",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF2B3649),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Fecha o diálogo
                                                        },
                                                        child: const Text(
                                                          "Cancelar",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF2B3649),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  border: Border.all(
                                                      color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Excluir família",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFF2B3649),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator();
      },
    );
  }

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2B3649),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 110.0,
                ),
                const Text(
                  'Familia',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3649),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              familyMembers(),
            ],
          ),
        ],
      ),
    );
  }

  //Adicionar membro da familia
  Future openBoxMembers() => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selecionar Usuário'),
            content: SizedBox(
              height: 300, // Define o tamanho da janela
              width: double.maxFinite,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Nenhum usuário registrado.'));
                  }
                  var users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: user['avatarColor'] != null
                                ? Color(int.parse(user['avatarColor']))
                                : Colors.grey.shade300,
                            child: Text(
                              user['name'] != null && user['name'].isNotEmpty
                                  ? user['name'][0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(user['name'] ?? 'Usuário sem nome'),
                          onTap: () {
                            // Adiciona o usuário à lista de membros da família
                            Navigator.of(context).pop(); // Fecha o popup
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
}
