import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 30,
              left: 30,
              top: 30,
              bottom: 10,
            ),
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              left: 100,
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
          Expanded(
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
                        //Avatar do devido usuário
                        leading: CircleAvatar(
                          backgroundColor: user['avatarColor'] != null
                              ? Color(int.parse(user['avatarColor']))
                              : Colors.grey
                                  .shade300,
                          child: Text(
                            user['name'] != null && user['name'].isNotEmpty
                                ? user['name'][0].toUpperCase()
                                : '?', // Inicial do nome
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        //Nome do devido usuário
                        title: Text(user['name'] ?? 'Usuário sem nome'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
