import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      // Customizando o tema da NavigationBar
      data: const NavigationBarThemeData(
        // Editando o tamanho e cor dos ícones da NavigationBar
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            size: 30,
            color: Color(0xFFEDE8E8), // Cor dos ícones não selecionados
          ),
        ),
        // Indicador da aba selecionada
        indicatorColor: Color.fromARGB(99, 255, 255, 255),
        backgroundColor: Color(0xFF577096), // Cor de fundo da NavigationBar

        // Editando o estilo de texto dos rótulos da NavigationBar
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 15,
            color: Color(0xFFEDE8E8),
          ),
        ),
      ),
      child: NavigationBar(
        // Atualiza a opção selecionada
        onDestinationSelected: onDestinationSelected,
        // Mostra qual opção está selecionada
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.miscellaneous_services_rounded),
            selectedIcon: Icon(
              Icons.miscellaneous_services_rounded,
              color: Color(0xFF577096), // Cor do ícone selecionado
            ),
            label: "Funcionalidades",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month,
              color: Color(0xFF577096),
            ),
            label: "Calendário",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(
              Icons.person_2,
              color: Color(0xFF577096), // Cor do ícone selecionado
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}