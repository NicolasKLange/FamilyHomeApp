import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../../../database/database.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime selectedDate = DateTime.now();
  TextEditingController taskController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots();
  }

  //Dialog para adicionar tarefa do dia
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Color(0xFF577096),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  const Text(
                    'Adicionar Tarefa',
                    style: TextStyle(
                      color: Color(0xFF2B3649),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Descrição',
                style: TextStyle(
                  color: Color(0xFF2B3649),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Descrição da tarefa',
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  if (taskController.text.isNotEmpty) {
                    _databaseMethods.addTask(selectedDate, taskController.text);
                    taskController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Center(
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF577096),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Adicionar',
                        style: TextStyle(
                          color: Color(0xFFEDE8E8),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    int todayIndex = selectedDate.day - 1;
    _scrollController.animateTo(
      todayIndex * 60.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                  Image.asset('lib/assets/images/logoApp.png', height: 40),
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
                    icon: const Icon(Icons.logout, color: Color(0xffEDE8E8)),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            margin:
                const EdgeInsets.only(right: 43, left: 43, top: 30, bottom: 10),
            padding: const EdgeInsets.only(bottom: 5, top: 5, left: 20),
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
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(
                  width: 40,
                ),
                const Text(
                  ("Tarefas"),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          //Dia de hoje baseado no dia selecionado
          Text(
            DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(selectedDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          //Calendário scrolável
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                23, // 7 dias para trás + 15 dias para frente + o dia atual
                (index) {
                  DateTime date = DateTime.now()
                      .subtract(const Duration(days: 7))
                      .add(Duration(days: index));
                  DateTime today = DateTime.now();

                  bool isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;
                  bool isSelected = selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                  // Verificar se o dia é passado, excluindo o dia de hoje
                  bool isPastDay = date.isBefore(today);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 68,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 17),
                      decoration: BoxDecoration(
                        color: isToday
                            ? (isSelected
                                ? const Color(
                                    0xff577096) // Cor de seleção para o dia de hoje
                                : const Color(
                                    0xffEDE8E8)) // Cor fixa para o dia de hoje, caso não esteja selecionado
                            : isSelected
                                ? const Color(
                                    0xff577096) // Cor para o dia selecionado
                                : isPastDay && !isToday
                                    ? const Color(
                                        0xffD2D2D2) // Cor para dias passados
                                    : const Color(0xffEDE8E8), // Cor padrão

                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: const Color(0xff2B3649)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff2B3649).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(3, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Dia da semana
                          Text(
                            DateFormat('E', 'pt_BR')
                                .format(date)
                                .replaceAll('.', '')
                                .capitalize(),
                            style: TextStyle(
                              color: isToday
                                  ? const Color(0xff2B3649)
                                  : isSelected
                                      ? const Color(0xffEDE8E8)
                                      : isPastDay && !isToday
                                          ? const Color(0xff909090)
                                          : const Color(0xff2B3649),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Dia
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              color: isToday
                                  ? const Color(0xff2B3649)
                                  : isSelected
                                      ? const Color(0xffEDE8E8)
                                      : isPastDay && !isToday
                                          ? const Color(0xff909090)
                                          : const Color(0xff414B5B),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          // Tarefas
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tarefas",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: selectedDate.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)))
                        ? null
                        : _showAddTaskDialog, // Desativa o botão se for dias passados
                    color: selectedDate.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)))
                        ? Colors.grey
                        : null, // Muda a cor para indicar que está desativado
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: DatabaseMethods().getTasks(selectedDate),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Não possui nenhuma tarefa neste dia!",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0XFF2B3649),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                        color: const Color(0xffEDE8E8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0XFF2B3649), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: const Color(0XFF577096),
                            value: doc['completed'],
                            onChanged: (value) {
                              DatabaseMethods().toggleTaskCompletion(
                                doc.id,
                                doc['completed'],
                              );
                            },
                          ),
                          title: Text(doc['description']),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0XFF2B3649),
                            ),
                            onPressed: () {
                              DatabaseMethods().deleteTask(doc.id);
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
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

//Extensão para deixar a primeira letra do dia da semana maiúsculo
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
 