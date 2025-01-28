import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addTask(DateTime date, String taskDescription) async {
    final taskDoc = _firestore
        .collection('Tasks')
        .doc(userId)
        .collection('UserTasks')
        .doc(date.toIso8601String());

    final snapshot = await taskDoc.get();

    if (snapshot.exists) {
      await taskDoc.update({
        'tasks': FieldValue.arrayUnion([taskDescription]),
      });
    } else {
      await taskDoc.set({
        'tasks': [taskDescription],
      });
    }
  }

  Future<List<String>> getTasks(DateTime date) async {
    final taskDoc = _firestore
        .collection('Tasks')
        .doc(userId)
        .collection('UserTasks')
        .doc(date.toIso8601String());

    final snapshot = await taskDoc.get();
    if (snapshot.exists) {
      return List<String>.from(snapshot.data()!['tasks']);
    }
    return [];
  }

  Future<void> deleteTask(DateTime date, String taskDescription) async {
    final taskDoc = _firestore
        .collection('Tasks')
        .doc(userId)
        .collection('UserTasks')
        .doc(date.toIso8601String());

    await taskDoc.update({
      'tasks': FieldValue.arrayRemove([taskDescription]),
    });
  }
}
