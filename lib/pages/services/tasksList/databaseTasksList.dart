import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseTasksList {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adicionar uma nova tarefa
  static Future<void> addTask(String userId, DateTime date, String description) async {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    await _firestore.collection('Users').doc(userId).collection('Tasks').add({
      'description': description,
      'completed': false,
      'date': formattedDate,
    });
  }

  // Obter tarefas para um dia específico
  static Stream<QuerySnapshot> getTasks(String userId, DateTime date) {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .where('date', isEqualTo: formattedDate)
        .snapshots();
  }

  // Marcar uma tarefa como concluída
  static Future<void> toggleTaskCompletion(String userId, DateTime date, String taskId, bool currentStatus) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .doc(taskId)
        .update({'completed': !currentStatus});
  }

  // Deletar uma tarefa
  static Future<void> deleteTask(String userId, DateTime date, String taskId) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .doc(taskId)
        .delete();
  }
}