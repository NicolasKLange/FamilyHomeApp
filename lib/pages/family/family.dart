import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  String? familyName;
  List<String> members = [];

  void _createFamily() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text("Criar Família"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Nome da Família"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  familyName = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Criar"),
            )
          ],
        );
      },
    );
  }

  void _deleteFamily() {
    setState(() {
      familyName = null;
      members.clear();
    });
  }

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Membro"),
          content: Container(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum usuário registrado.'));
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
                      title: Text(user['name'] ?? 'Usuário sem nome'),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (!members.contains(user['name'])) {
                              members.add(user['name']);
                            }
                          });
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
                            bottom: 10,
                            top: 20,
                            left: 30,
                            right: 30,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE8E8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFF2B3649), width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 7),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      familyName!,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add,
                                        color: Color(0xFF2B3649)),
                                    onPressed: _addMember,
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteFamily();
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Excluir Família'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              top: 10,
                              left: 23,
                              right: 20,
                            ),
                            child: ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                final member = members[index];
                                return ListTile(
                                  leading: CircleAvatar(child: Text(member[0])),
                                  title: Text(member),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        members.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              },
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
}