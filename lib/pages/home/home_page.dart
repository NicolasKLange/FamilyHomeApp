import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../assets/components/navigation_bar/custom_navigation_bar.dart';
import '../family/family.dart';
import '../profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _opcaoSelecionada = 0;

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots();
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
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEDE8E8),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xffEDE8E8),
                    ),
                    onPressed: () => _showOptionsModal(context),
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
        automaticallyImplyLeading:
            false, // Remove o botão de voltar automaticamente
      ),

      // Selecionar tela da NavigationBar
      body: IndexedStack(
        index: _opcaoSelecionada,
        children: const <Widget>[
          FuncionalidadesScreen(),
          FamilyScreen(),
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

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0XFFEDE8E8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Color(0xFF2B3649)),
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
}

class FuncionalidadesScreen extends StatelessWidget {
  const FuncionalidadesScreen({super.key});

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon, String route) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E8),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: const Color(0xFF2B3649), width: 2),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
      body: Padding(
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
                left: 43,
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
                  SizedBox(width: 20.0),
                  Text(
                    'Funcionalidades',
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
                  _buildDashboardButton(
                      context, 'Compras', Icons.shopping_cart, '/shopping'),
                  _buildDashboardButton(
                      context, 'Tarefas', Icons.list, '/tasksList'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
