import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Family Home',
      //USANDO LOCALIZATION PARA TRADUZIR A DATA PARA PORTUGUÊS
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
      ],
      //CHAMANDO A CLASSE PRINCIPAL DA TELA
      home: TasksScreen(),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // O DIA SELECIONADO NO LISTVIEW COMEÇA NO DIA ATUAL
  int _selectedDay = DateTime.now().day;

  // VARIÁVEL ARMAZENA A DATA ATUAL, PODENDO SER MODIFICADA COM BASE NO DIA SELECIONADO
  DateTime _currentDate = DateTime.now();

  // ScrollController PARA CONTROLAR O SCROLL DA LISTA (COMEÇA NO DIA ATUAL)
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // INICIALIZANDO O ScrollController
    _scrollController = ScrollController();

    // COMANDO PARA APÓS INICIAR A TELA ROLAR PARA O DIA ATUAL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  // FUNÇÃO PARA ROLAR ATÉ O DIA ATUAL AUTOMATICAMENTE
  void _scrollToSelectedDay() {
    //CALCULANDO A POSIÇÃO EM QUE O ITEM IRÁ FICAR DE ACORDO COM O DIA ATUAL
    double itemWidth = 70.0;
    double targetPosition = (_selectedDay - 2) * itemWidth;

    // SCROLL ATÉ O DIA ATUAL
    _scrollController.animateTo(
      targetPosition,
      // DURAÇÃO DO SCROLL
      duration: const Duration(milliseconds: 500),
      // ANIMAÇÃO DO SCROLL
      curve: Curves.slowMiddle,
    );
  }

  // FUNÇÃO QUE OBTÉM QUANTIDADE DE DIAS DO MÊS ATUAL
  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    //QUANTIDADE DE DIAS DO MÊS ATUAL
    int totalDaysInMonth =
        getDaysInMonth(_currentDate.year, _currentDate.month);

    return Scaffold(
      backgroundColor: const Color(0xFF577096),
      body: SingleChildScrollView(
        
          child: Column(
            children: [
              // LINHA COM BOTÃO DE VOLTAR E DIA SELECIONADO
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: const Color(0xFF2B3649),
                    onPressed: () {
                      Navigator.pushNamed(context, '/homePage');
                    },
                  ),
                  const SizedBox(
                    width: 25,
                    height: 80,
                  ),
                  // DATA FORMATADA DE ACORDO COM O DIA SELECIONADO
                  Text(
                    DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(
                      DateTime(
                          _currentDate.year, _currentDate.month, _selectedDay),
                    ),
                    
                  ),
                ],
              ),

              // LISTA COM OS DIAS DO MÊS
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: totalDaysInMonth,
                  itemBuilder: (context, index) {
                    //O DIA É O ÍNDICE + 1, USADO PARA COLOCAR OS DIAS NA LISTA
                    int day = index + 1;
                    DateTime dayDate =
                        DateTime(_currentDate.year, _currentDate.month, day);

                    // VERIFICA SE O DIA É PASSADO AO DIA ATUAL, PARA QUE POSSA DEIXAR E CINZA CLARO, NÃO SENDO MAIS POSSÍVEL VISUALIZAR
                    bool isPast = dayDate.isBefore(DateTime.now());

                    return GestureDetector(
                      // SE O DIA FOR PASSADO NÃO SERÁ MAIS POSSÍVEL CLICAR NO MESMO
                      onTap: isPast
                          ? null
                          : () {
                              // DIA SELECIONADO É ATUALIZADO
                              setState(() {
                                _selectedDay = day;
                              });
                            },

                      child: Container(
                        width: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          // COR PARA OS DIAS
                          color: _selectedDay == day
                              ? const Color(0xFFA8BEE0)
                              : isPast
                                  ? Colors.grey[300]
                                  : const Color(0xFFEDE8E8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF2B3649),
                            width: 2,
                          ),
                          // Sombra arredondada que não fica reta em cima ou embaixo
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2B3649)
                                  .withOpacity(0.3), // Sombra mais suave
                              spreadRadius:
                                  -2, // Faz com que a sombra não fique nas bordas superiores
                              blurRadius: 10, // Desfoca a sombra
                              offset: const Offset(
                                  0, 8), // Desloca a sombra apenas para baixo
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // NOME DO DIA
                            Text(
                              DateFormat.E('pt_BR').format(dayDate),
                              style: TextStyle(
                                color: _selectedDay == day
                                    ? const Color(0xFF2B3649)
                                    : isPast
                                        ? Colors.grey
                                        : const Color(0xFF2B3649),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            // NÚMERO DO DIA
                            Text(
                              day.toString(),
                              style: TextStyle(
                                color: _selectedDay == day
                                    ? const Color(0xFF2B3649)
                                    : isPast
                                        ? Colors.grey
                                        : const Color(0xFF2B3649),
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Row(
                children: [
                  const SizedBox(
                    width: 40,
                    height: 100,
                  ),
                  const Text(
                    "Tarefas",
                    
                  ),
                  const SizedBox(
                    width: 180,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: const Color(0xFF2B3649),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tasksScreen');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    
  }
}