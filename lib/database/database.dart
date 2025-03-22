import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // =============== FAMÍLIA ===============

  // Criar uma nova família
  Future<String> createFamily(String familyName) async {
    DocumentReference familyDoc = await _firestore.collection('Families').add({
      'nome': familyName,
    });

    String familyId = familyDoc.id;

    // Atualiza o usuário atual com o idFamilia
    await _firestore.collection('Users').doc(userId).update({
      'idFamilia': familyId,
    });

    return familyId;
  }

  // Adicionar um membro à família
  Future<void> addMemberToFamily(String userId, String familyId) async {
    await _firestore.collection('Users').doc(userId).update({
      'idFamilia': familyId,
    });
  }

  // Obter informações da família
  Future<DocumentSnapshot> getFamily(String familyId) async {
    return await _firestore.collection('Families').doc(familyId).get();
  }

  // Excluir uma família (e remover idFamilia dos membros)
  Future<void> deleteFamily(String familyId) async {
    // Remove o idFamilia de todos os membros antes de excluir a família
    QuerySnapshot usersInFamily = await _firestore
        .collection('Users')
        .where('idFamilia', isEqualTo: familyId)
        .get();

    for (var user in usersInFamily.docs) {
      await user.reference.update({'idFamilia': null});
    }

    // Exclui a família do banco de dados
    await _firestore.collection('Families').doc(familyId).delete();
  }

  // Método para recuperar o ID da família associado ao usuário
  Future<String?> getFamilyId() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc['idFamilia']; // Retorna o ID da família
    } else {
      return null; // Caso o usuário não tenha um ID de família
    }
  }

  Future<List<Map<String, dynamic>>> getFamilyMembers(String familyId) async {
    QuerySnapshot membersSnapshot = await _firestore
        .collection('Users')
        .where('idFamilia', isEqualTo: familyId)
        .get();

    return membersSnapshot.docs.map((doc) {
      return {
        'id': doc.id, // ID do documento (usuário)
        'name': doc['name'], // Nome do membro
        'avatarColor':
            doc['avatarColor'] ?? 'defaultColor', // Cor do avatar (caso tenha)
      };
    }).toList();
  }

  // ========== PERFIL DO USUÁRIO ==========

  // Inicializar o perfil do usuário ao criar conta
  Future<void> initializeUserProfile(String email, String userId) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': email, // Nome inicial baseado no e-mail
        'birthdate': null,
        'idFamilia': null, // Inicialmente sem família
        'id': userId, // Adiciona o id
      });
    }
  }

  // Atualizar informações do perfil do usuário
  Future<void> updateUserProfile(
      String name, String? birthdate, String userId) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    await userDoc.update({
      'name': name,
      'birthdate': birthdate,
    });
  }

  // Obter informações do perfil do usuário
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('Users').doc(userId).get();
  }

  // Remover membro da família e definir idFamilia como null
  Future<void> removeMemberFromFamily(String userId) async {
    // Atualiza o idFamilia do usuário para null
    await _firestore.collection('Users').doc(userId).update({
      'idFamilia': null,
    });
  }

  // Remover membro da família e exibir mensagem de exclusão
  Future<void> removeMemberToFamily(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      String userName = userDoc['name'];

      // Define idFamilia como null para remover da família
      await _firestore.collection('Users').doc(userId).update({
        'idFamilia': null,
      });

      // Salvar notificação da remoção (Opcional: pode ser armazenado em um log)
      await _firestore.collection('Notifications').add({
        'message': '$userName foi excluído da família.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('$userName foi excluído da família.');
    }
  }

  // ========== LISTA DE COMPRAS ==========

  // Adicionar um produto a uma categoria específica
  Future<void> addProduct(String familyId, String category,
      Map<String, dynamic> productData, String id) async {
    return await _firestore
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .doc(id)
        .set(productData);
  }

  // Obter produtos de uma categoria específica
  Stream<QuerySnapshot> getProducts(String familyId, String category) {
    return _firestore
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .snapshots();
  }

  // Atualizar o status "Yes" de um produto
  Future<void> updateIfTicked(
      String familyId, String category, String id, bool newValue) async {
    return await _firestore
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .doc(id)
        .update(
            {'Yes': newValue}); // Agora atualiza dinamicamente com o novo valor
  }

  // Remover toda a lista de compras de uma categoria
  Future<void> deleteProductList(String familyId, String category) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products');

    final querySnapshot = await collectionRef.get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  //Função para verificar produtos que foram comprados ainda, para mostrar na tela dashboardShopping
  Stream<QuerySnapshot> getProductsNotBought(String familyId, String category) {
    return FirebaseFirestore.instance
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .where('Yes', isEqualTo: false) // Filtra apenas os itens não comprados
        .snapshots();
  }

  // ============ TAREFAS ============

  // Adicionar uma nova tarefa à família
  Future<void> addTask(
      String familyId, DateTime date, String description) async {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    await _firestore
        .collection('Families')
        .doc(familyId)
        .collection('Tasks')
        .add({
      'description': description,
      'completed': false,
      'date': formattedDate,
    });
  }

  // Obter tarefas de um dia específico para a família
  Stream<QuerySnapshot> getTasks(String familyId, DateTime date) {
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    return FirebaseFirestore.instance
        .collection('Families')
        .doc(familyId)
        .collection('Tasks')
        .where('date', isEqualTo: formattedDate)
        .snapshots();
  }

  Future<void> toggleTaskCompletion(
      String familyId, String taskId, bool completed) async {
    await _firestore
        .collection('Families') // Acesso correto à coleção 'Families'
        .doc(familyId)
        .collection('Tasks')
        .doc(taskId)
        .update({
      'completed': completed
    }); // Atualiza o campo 'completed' com o valor de 'completed'
  }

  Future<void> deleteTask(String familyId, String taskId) async {
    await _firestore
        .collection('Families') // Altere de 'Users' para 'Families'
        .doc(familyId)
        .collection('Tasks')
        .doc(taskId)
        .delete(); // Exclui a tarefa
  }
}

class ShoppingDatabaseMethods {
  Stream<QuerySnapshot> getProductsNotBought(String familyId, String category) {
    return FirebaseFirestore.instance
        .collection('Families')
        .doc(familyId)
        .collection('ShoppingLists')
        .doc(category)
        .collection('Products')
        .where('Yes', isEqualTo: false)
        .snapshots();
  }
}
