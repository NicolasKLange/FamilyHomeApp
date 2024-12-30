import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../assets/components/navigation_bar/customNavigationBar.dart';
// Importando as telas
import '../calendar/calendar.dart';
import '../profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _opcaoSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),

      //AppBar com logo e email do login
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logoApp.png',
              height: 40,
            ),
            const SizedBox(width: 10),
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

      //Selecionar tela da NavigationBar
      body: IndexedStack(
        index: _opcaoSelecionada,
        children: const <Widget>[
          FuncionalidadesScreen(),
          CalendarScreen(),
          ProfileScreen(),
        ],
      ),

      //NavigationBar
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

class FuncionalidadesScreen extends StatelessWidget {
  const FuncionalidadesScreen({super.key});

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon, String route) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E8),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: const Color(0xFF2B3649), width: 2),
        //COLOCANDO SOMBRA PARA PARECER FLUTURAR
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
          const Padding(
            padding: EdgeInsets.only(bottom: 10, top: 20),
            child: Text(
              'Funcionalidades',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                _buildDashboardButton(context, 'Funcionário', Icons.person, '/listEmployes'),
                _buildDashboardButton(context, 'Compras', Icons.shopping_cart, '/supermarket'),
                _buildDashboardButton(context, 'Tarefas', Icons.list, '/toDoList'),
                _buildDashboardButton(context, 'Tasks', Icons.list, '/tasksList'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

