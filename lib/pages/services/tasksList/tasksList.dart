import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';
import 'databaseTasksList.dart'; // Importa a lógica do banco de dados

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _tasks = [];
  final TaskDatabaseMethods _taskDatabase = TaskDatabaseMethods();

  // Variáveis para o usuário
  final user = FirebaseAuth.instance.currentUser!;

  // Stream que observa os dados do usuário no Firestore
  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots();
  }

  void _fetchTasks() async {
    if (_selectedDay != null) {
      final tasks = await _taskDatabase.getTasks(_selectedDay!);
      setState(() {
        _tasks = tasks;
      });
    }
  }

  void _addTask(String taskDescription) async {
    if (_selectedDay != null) {
      await _taskDatabase.addTask(_selectedDay!, taskDescription);
      _fetchTasks();
    }
  }

  void _deleteTask(String taskDescription) async {
    if (_selectedDay != null) {
      await _taskDatabase.deleteTask(_selectedDay!, taskDescription);
      _fetchTasks();
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Tarefa'),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(hintText: 'Descrição da tarefa'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                _addTask(taskController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Seção de "Funcionalidades"
          Padding(
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
                    bottom: 5,
                    top: 5,
                    left: 20,
                    right: 20,
                  ),
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF2B3649)),
                        onPressed: () {
                          Navigator.pop(
                              context); // Volta para a página anterior
                        },
                      ),
                      const SizedBox(width: 35.0),
                      const Text(
                        'Tarefas',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B3649),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // TableCalendar
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 35.0), 
            decoration: BoxDecoration(
              color: const Color(0XFFEDE8E8),
              borderRadius: BorderRadius.circular(10.0), 
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, 
                  blurRadius: 5.0,
                  offset: Offset(0, 3), 
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchTasks();
                _showAddTaskDialog();
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0XFF577096),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0XFFEDE8E8),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Color(0XFF2B3649),),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          // Lista de tarefas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 30, left: 30.0), 
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0), 
                    decoration: BoxDecoration(
                      color: const Color(0xffEDE8E8), 
                      border: Border.all(
                          color: const Color(0xFF577096), width: 3), 
                      borderRadius:
                          BorderRadius.circular(8.0), 
                    ),
                    child: ListTile(
                      title: Text(task, style: const TextStyle(color: Color(0xFF577096), fontSize: 16, fontWeight: FontWeight.bold),),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteTask(task);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
