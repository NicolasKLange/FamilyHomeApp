import 'package:family_home_app/pages/services/supermarket/supermarket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../assets/components/navigation_bar/customNavigationBar.dart';
// Importando as telas
import '../calendar/calendar.dart';
import '../profile/profile.dart';
import '../../testeFirebase/listEmployes.dart';
import '../../testeFirebase/employee.dart'; // Certifique-se de que essa importação aponta para a tela correta

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
      //Cor de fundo azul em toda a tela
      backgroundColor:const  Color(0xFFA8BEE0), // Aqui definimos o fundo azul para toda a tela

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

  Widget buildSquare(BuildContext context, String title, Color color, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Funcionalidades',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSquare(context, 'Funcionário', Colors.blue, ListEmployes()),
                const SizedBox(width: 20),
                buildSquare(context, 'Compras', Colors.green, Supermarket()),
              ],
            ),
          ],
        ),
    );
  }
}

class CustomScreenHeader extends StatelessWidget {
  final Widget child;

  const CustomScreenHeader({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child, // Aqui está o conteúdo do header
        ],
      ),
    );
  }
}
