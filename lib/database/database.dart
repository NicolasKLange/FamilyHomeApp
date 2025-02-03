import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid; // Obtém o UID do usuário autenticado

  // ========== PERFIL DO USUÁRIO ==========

  // Inicializar o perfil do usuário ao criar conta
  Future<void> initializeUserProfile(String email) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': email, // Nome inicial baseado no e-mail
        'cpf': null,
        'birthdate': null,
      });
    }
  }

  // Atualizar informações do perfil do usuário
  Future<void> updateUserProfile(String name, String? cpf, String? birthdate) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    await userDoc.update({
      'name': name,
      'cpf': cpf,
      'birthdate': birthdate,
    });
  }

  // Obter informações do perfil do usuário
  Future<DocumentSnapshot> getUserProfile() async {
    return await _firestore.collection('Users').doc(userId).get();
  }

  // ========== LISTA DE COMPRAS ==========

  // Adicionar um produto a uma categoria específica
  Future<void> addProduct(
      String category, Map<String, dynamic> userShoppingMap, String id) async {
    return await _firestore
        .collection('Users')
        .doc(userId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .doc(id)
        .set(userShoppingMap);
  }

  // Obter produtos de uma categoria específica
  Stream<QuerySnapshot> getProducts(String category) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .snapshots();
  }

  // Atualizar o status "Yes" de um produto
  Future<void> updateIfTicked(String category, String id) async {
    return await _firestore
        .collection('Users')
        .doc(userId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .doc(id)
        .update({'Yes': true});
  }

  // Remover toda a lista de compras de uma categoria
  Future<void> deleteProductList(String category) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products');

    final querySnapshot = await collectionRef.get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ========== TAREFAS ==========

  // Adicionar uma nova tarefa
  Future<void> addTask(DateTime date, String description) async {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    await _firestore.collection('Users').doc(userId).collection('Tasks').add({
      'description': description,
      'completed': false,
      'date': formattedDate,
    });
  }

  // Obter tarefas para um dia específico
  Stream<QuerySnapshot> getTasks(DateTime date) {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .where('date', isEqualTo: formattedDate)
        .snapshots();
  }

  // Marcar uma tarefa como concluída
  Future<void> toggleTaskCompletion(String taskId, bool currentStatus) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .doc(taskId)
        .update({'completed': !currentStatus});
  }

  // Deletar uma tarefa
  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Tasks')
        .doc(taskId)
        .delete();
  }
}
