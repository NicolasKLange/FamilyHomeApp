import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../assets/components/navigation_bar/customNavigationBar.dart';
import '../../calendar/calendar.dart';
import '../../profile/profile.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  final user = FirebaseAuth.instance.currentUser!;
  int _opcaoSelecionada = 0;

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),

      // AppBar com logo e nome do usuário
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        title: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userName = snapshot.data!['name'] ?? 'Usuário';
              return Row(
                children: [
                  Image.asset(
                    'lib/assets/images/logoApp.png',
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEDE8E8),
                    ),
                  ),
                ],
              );
            }
            return const Text(
              'Carregando...',
              style: TextStyle(fontSize: 16, color: Color(0xFFEDE8E8)),
            );
          },
        ),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),

      // Selecionar tela da NavigationBar
      body: IndexedStack(
        index: _opcaoSelecionada,
        children: const <Widget>[
          ShoppingScreen(),
          CalendarScreen(),
          ProfileScreen(),
        ],
      ),

      // NavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _opcaoSelecionada,
        onDestinationSelected: (int index) {
          setState(() {
            _opcaoSelecionada = index;
          });
        },
      ),
    );
  }
}

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon, String route) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E8),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: const Color(0xFF2B3649), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B3649).withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: const Color(0xFF2B3649),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 55.0,
                ),
                const Text(
                  'Compras',
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
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              shrinkWrap: true,
              padding: const EdgeInsets.all(30),
              childAspectRatio: 1,
              children: [
                _buildDashboardButton(context, 'Mercado', Icons.fastfood_rounded, '/supermarket'),
                _buildDashboardButton(context, 'Farmácia', Icons.local_pharmacy_rounded, '/pharmacy'),
                _buildDashboardButton(context, 'Roupas', Icons.store_mall_directory, '/clothes'),
                _buildDashboardButton(context, 'Escola', Icons.school_rounded, '/school'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
