import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<String> selectedUsers = []; // Lista para armazenar os nomes dos usuários selecionados

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
             margin:
                const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              left: 110,
              right: 30,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2B3649),
                width: 2,
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Família',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3649),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            
            child: Container(
              margin:
                const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8E8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF2B3649),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nome família',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF2B3649),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Ícone de adicionar membro
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFF2B3649),
                        ),
                        onPressed: () {
                          // Ao clicar, exibe o popup com os usuários
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Selecionar Usuário'),
                                //Aqui adicionar
                                content: SizedBox(
                                  height: 300, // Define o tamanho da janela
                                  width: double.maxFinite,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return const Center(child: Text('Nenhum usuário registrado.'));
                                      }
                                      var users = snapshot.data!.docs;
                                      return ListView.builder(
                                        itemCount: users.length,
                                        itemBuilder: (context, index) {
                                          var user = users[index];
                                          return Card(
                                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                                    // Adiciona o usuário à lista
                                                    setState(() {
                                                      selectedUsers.add(user['name']);
                                                    });
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
                        },
                      ),
                      // Três pontinhos
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor:
                                Colors.transparent, // Fundo transparente
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              "Confirmar Exclusão",
                                              style: TextStyle(
                                                  color: Color(0xFF2B3649),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFEDE8E8),
                                            content: const Text(
                                              "Você realmente deseja excluir esta família?",
                                              style: TextStyle(
                                                color: Color(0xFF2B3649),
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
                                                    color: Color(0xFF2B3649),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              // Adicionar função para excluir família
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o diálogo
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o menu
                                                },
                                                child: const Text(
                                                  "Excluir",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          border: Border.all(color: Colors.red),
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
                                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }

}
