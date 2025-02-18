import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../database/database.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  String? familyName;
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  Future<void> _loadFamilyData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid; // Obtém o ID do usuário

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc['idFamilia'] != null) {
        String familyId = userDoc['idFamilia'];

        DocumentSnapshot familyDoc = await FirebaseFirestore.instance
            .collection('Families')
            .doc(familyId)
            .get();

        if (familyDoc.exists) {
          setState(() {
            familyName = familyDoc['nome'];
          });

          // Agora buscamos os membros da família
          QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .where('idFamilia', isEqualTo: familyId)
              .get();

          for (var doc in membersSnapshot.docs) {
            print("ID: ${doc.id}, Data: ${doc.data()}");
          }

          setState(() {
            members = membersSnapshot.docs.map((doc) {
              return {
                'id': doc.id, // Adiciona o ID do usuário
                'name': doc['name'] ?? 'Usuário sem nome',
                'avatarColor': doc['avatarColor'] ?? '0xFFBDBDBD',
              };
            }).toList();
          });
        }
        print("Lista de membros: $members");
      }
    }
  }

  //Funação para excluir família
  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                    Navigator.of(context).pop();
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: const Color(0xFFEDE8E8),
                      content: const Text(
                        "Você realmente deseja excluir esta família?",
                        style: TextStyle(
                          color: Color(0xFF2B3649),
                          fontSize: 15,
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(
                                  color: Color(0xFF2B3649),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteFamily();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF577096),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Excluir',
                                  style: TextStyle(
                                    color: Color(0xFFEDE8E8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
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
  }

  void _createFamily() async {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "Criar Família",
                style: TextStyle(
                  color: Color(0xFF2B3649),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Color(0XFF577096),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo ao clicar
                },
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Nome da Família",
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                String familyName = controller.text;

                // Cria a família no Firestore
                String familyId =
                    await DatabaseMethods().createFamily(familyName);

                // Atualiza o estado local com o nome da família e membros vazios
                setState(() {
                  this.familyName = familyName;
                  members = []; // Inicializa com uma lista vazia
                });

                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0XFF577096),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Criar",
                    style: TextStyle(
                      color: Color(0xFFEDE8E8),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteFamily() async {
    // Verifica se o ID da família está disponível
    String? familyId = await DatabaseMethods().getFamilyId();

    if (familyId != null) {
      // Chama o método deleteFamily para remover a família do Firestore
      await DatabaseMethods().deleteFamily(familyId);

      // Limpa as informações no estado local
      setState(() {
        familyName = null;
        members.clear();
      });

      // Feedback para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Família excluída com sucesso!')),
      );
    } else {
      // Caso o usuário não tenha uma família associada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você não está associado a uma família')),
      );
    }
  }

  void _deleteMember(String memberId) async {
    // Obtém o ID da família
    String? familyId = await DatabaseMethods().getFamilyId();

    if (familyId != null) {
      try {
        // Acesse a coleção correta e remova o membro
        await FirebaseFirestore.instance
            .collection('Families')
            .doc(familyId)
            .collection('Members')
            .doc(memberId)
            .delete();

        // Atualiza a lista removendo o membro localmente
        setState(() {
          members.removeWhere((member) => member['id'] == memberId);
        });

        // Feedback para o usuário
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membro removido com sucesso!')),
        );
      } catch (e) {
        // Caso ocorra um erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover membro: $e')),
        );
      }
    } else {
      // Caso o usuário não tenha uma família associada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você não está associado a uma família')),
      );
    }
  }

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Adicionar Membro",
            style: TextStyle(
              color: Color(0xFF2B3649),
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Container(
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
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListTile(
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
                      title: Text(
                        user['name'] ?? 'Usuário sem nome',
                        style: TextStyle(
                          color: Color(0xFF2B3649),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          // Verifica se o membro já foi adicionado
                          setState(() {
                            if (!members
                                .any((m) => m['name'] == user['name'])) {
                              members.add({
                                'name': user['name'],
                                'avatarColor':
                                    user['avatarColor'] ?? '0xFFBDBDBD',
                              });
                            }
                          });

                          // Recupera o ID da família (supondo que você tenha esse ID)
                          String? familyId =
                              await DatabaseMethods().getFamilyId();

                          if (familyId != null) {
                            // Adiciona o membro à família no banco de dados
                            await DatabaseMethods()
                                .addMemberToFamily(user.id, familyId);

                            // Exibe mensagem de sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${user['name']} adicionado à família')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Você não está associado a uma família')),
                            );
                          }
                          Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFA8BEE0),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2B3649), width: 2),
            ),
            child: Center(
              child: Text(
                'Família',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B3649),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: familyName == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Você não possui nenhuma família cadastrada",
                          style:
                              TextStyle(fontSize: 17, color: Color(0XFF2B3649)),
                        ),
                        TextButton(
                          onPressed: _createFamily,
                          child: Text(
                            "Criar Família",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0XFF2B3649),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 20, left: 30, right: 30),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE8E8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFF2B3649), width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        familyName!,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add,
                                          color: Color(0xFF2B3649)),
                                      onPressed: _addMember,
                                    ),
                                    GestureDetector(
                                      onTap: _showMenuOptions,
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Color(0xFF2B3649),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Aqui vem a lógica de exibição dos membros
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future:
                                      _getFamilyMembers(), // Método para buscar membros
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Erro ao carregar membros."));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                          child: Text(
                                              "Nenhum membro encontrado."));
                                    } else {
                                      // Exibe a lista de membros
                                      var members = snapshot.data!;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: members.length,
                                        itemBuilder: (context, index) {
                                          var member = members[index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Color(int.parse(
                                                  member['avatarColor'])),
                                              child: Text(
                                                member['name'][0].toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            title: Text(
                                              member['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            subtitle: Text(member['id'] ??
                                                'ID não encontrado'),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Color(0xFF2B3649),
                                              ),
                                              onPressed: () async {
                                                await DatabaseMethods()
                                                    .removeMemberToFamily(
                                                        member['id']);
                                                setState(() {
                                                  members.removeAt(index);
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        '${member['name']} foi excluído da família.'),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFamilyMembers() async {
    String? familyId = await DatabaseMethods().getFamilyId();
    if (familyId != null) {
      return await DatabaseMethods().getFamilyMembers(familyId);
    } else {
      return [];
    }
  }
}
