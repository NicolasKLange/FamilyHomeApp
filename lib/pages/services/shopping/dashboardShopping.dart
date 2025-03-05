import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_home_app/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../assets/components/navigation_bar/customNavigationBar.dart';
import '../../family/family.dart';
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
        children: <Widget>[
          ShoppingScreen(),
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

class ShoppingScreen extends StatelessWidget {
  ShoppingScreen({super.key});

  final ShoppingDatabaseMethods shoppingDB = ShoppingDatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
      body: Center(
        child: FutureBuilder<String?>(
          future: DatabaseMethods().getFamilyId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 43, vertical: 30),
                    padding: const EdgeInsets.only(bottom: 5, top: 5, left: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8E8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2B3649), width: 2),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 40),
                        const Text(
                          'Compras', 
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 300),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Você não pertence a uma família"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/homePage');
                          },
                          child: const Text(
                            "Toque aqui para voltar e criar uma família",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B3649),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // Se o usuário pertence a uma família, mostra a tela de compras normalmente
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: CircularProgressIndicator());
                }

                final String familyId = snapshot.data!['idFamilia'] ?? '';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeader(context),
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
                                context,
                                'Mercado',
                                Icons.fastfood_rounded,
                                '/supermarket',
                                'Mercado',
                                familyId),
                            _buildDashboardButton(
                                context,
                                'Farmácia',
                                Icons.local_pharmacy_rounded,
                                '/pharmacy',
                                'Farmácia',
                                familyId),
                            _buildDashboardButton(
                                context,
                                'Roupas',
                                Icons.store_mall_directory,
                                '/clothes',
                                'Roupas',
                                familyId),
                            _buildDashboardButton(
                                context,
                                'Escola',
                                Icons.school_rounded,
                                '/school',
                                'Escola',
                                familyId),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


  Widget _buildDashboardButton(BuildContext context, String title,
      IconData icon, String route, String category, String familyId) {
    return StreamBuilder<QuerySnapshot>(
      stream: shoppingDB.getProductsNotBought(familyId, category),
      builder: (context, snapshot) {
        int itemCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Container(
          decoration: BoxDecoration(
            color: Color(0XFFEDE8E8),
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: const Color(0xFF2B3649), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, route);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, size: 50, color: const Color(0xFF2B3649)),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (itemCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 6, right: 8, left: 8, bottom: 6),
                    decoration: BoxDecoration(
                      color: Color(0XFF2B3649),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      itemCount.toString(),
                      style: const TextStyle(
                        color: Color(0XFFEDE8E8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2B3649), width: 2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 55.0),
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
    );
  }
}
