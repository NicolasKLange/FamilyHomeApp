import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../database/database.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String? familyName;
  List<Map<String, dynamic>> members = [];

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
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
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0XFF2B3649),
                          ),
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
                                      icon: Icon(
                                        Icons.add,
                                        color: Color(0xFF2B3649),
                                      ),
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
                                // Exibição dos membros
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future:
                                      _getFamilyMembers(), // Método para buscar membros
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child:
                                            Text("Erro ao carregar membros."),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child:
                                            Text("Nenhum membro encontrado."),
                                      );
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
                                              backgroundColor: Color(
                                                int.parse(
                                                  member['avatarColor'],
                                                ),
                                              ),
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

  //Carregar dados da família
  Future<void> _loadFamilyData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

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

          // Busca os membros da família
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
                'id': doc.id,
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

  //Função para excluir família
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
                                Navigator.of(context).pop();
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

  //Função para criar familia
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
                  Navigator.of(context).pop();
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

                //Lista dos membros, inicializa vazia
                setState(() {
                  this.familyName = familyName;
                  members = [];
                });

                Navigator.of(context).pop();
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

  //Função para deletar família
  void _deleteFamily() async {
    String? familyId = await DatabaseMethods().getFamilyId();

    if (familyId != null) {
      await DatabaseMethods().deleteFamily(familyId);

      setState(
        () {
          familyName = null;
          members.clear();
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Família excluída com sucesso!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você não está associado a uma família'),
        ),
      );
    }
  }

  //Adicionar membros a familia
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum usuário registrado.'),
                  );
                }
                var users = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    bool isUserInFamily = user['idFamilia'] != null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isUserInFamily
                            // Muda a cor do avatar para cinza
                            ? Colors.grey.shade300
                            : Color(
                                int.parse(user['avatarColor'] ?? '0xFFBDBDBD'),
                              ),
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
                          color: isUserInFamily
                              ? Colors.grey.shade500
                              : Color(0xFF2B3649),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.add,
                          color:
                              isUserInFamily ? Colors.grey : Color(0xFF2B3649),
                        ),
                        // Desabilita o botão se o usuário já estiver em uma família
                        onPressed: isUserInFamily
                            ? null
                            : () async {
                                // Verifica se o membro já foi adicionado
                                setState(
                                  () {
                                    if (!members.any(
                                      (m) => m['name'] == user['name'],
                                    )) {
                                      members.add({
                                        'name': user['name'],
                                        'avatarColor':
                                            user['avatarColor'] ?? '0xFFBDBDBD',
                                      });
                                    }
                                  },
                                );

                                String? familyId =
                                    await DatabaseMethods().getFamilyId();

                                if (familyId != null) {
                                  // Adiciona o membro à família no banco de dados
                                  await DatabaseMethods()
                                      .addMemberToFamily(user.id, familyId);

                                  // Exibe notifição de sucesso
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${user['name']} adicionado à família'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Você não está associado a uma família'),
                                    ),
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

  //Busca os membros da familia para aparecer na lista
  Future<List<Map<String, dynamic>>> _getFamilyMembers() async {
    try {
      String? familyId = await DatabaseMethods().getFamilyId();
      if (familyId != null) {
        return await DatabaseMethods().getFamilyMembers(familyId);
      } else {
        throw Exception("ID da família é nulo");
      }
    } catch (e) {
      print("Erro ao carregar membros: $e");
      return [];
    }
  }

  //Função para fazer logout
  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0XFFEDE8E8),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF2B3649),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: forgetAccountWithGoogle,
                icon: const Icon(Icons.email, color: Colors.red),
                label: const Text(
                  'Esquecer e-mail cadastrado',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: signUserOutWithEmailAndPassword,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Fazer logout
  void signUserOutWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'authPage');
  }

  //Esquecer email cadastrado
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
}
