import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../assets/components/navigation_bar/customNavigationBar.dart';
// Importando as telas
import '../dashboard/dashboard.dart';
import '../calendar/calendar.dart';
import '../profile/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _opcaoSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096), // Fundo vermelho no AppBar
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logoApp.png', // Caminho da imagem do logotipo
              height: 40, // Altura do logotipo
            ),
            const SizedBox(width: 10), // Espaçamento entre o logotipo e o texto
            // const Text(
            //   "Family Home",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFEDE8E8),),
            // ),

            // Colocar o email do usuario(Futuramente colocar nome de usuário cadastrado)
            Text(
              user.email!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFEDE8E8),
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _opcaoSelecionada,
        children: const <Widget>[
          DashboardScreen(),
          CalendarScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
