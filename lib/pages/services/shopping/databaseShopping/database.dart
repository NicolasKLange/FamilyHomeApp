import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoppingDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid; // Obtém o UID do usuário autenticado

  // Adicionar um produto a uma categoria específica
  Future<void> addProduct(
      String category, Map<String, dynamic> userShoppingMap, String id) async {
    return await _firestore
        .collection('ShoppingLists') 
        .doc(userId) 
        .collection(category) 
        .doc(id) 
        .set(userShoppingMap); 
  }

  // Obter produtos de uma categoria específica
  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return _firestore
        .collection('ShoppingLists') 
        .doc(userId) 
        .collection(category) 
        .snapshots(); 
  }

  // Atualizar o status "Yes" de um produto
  Future<void> updateIfTicked(String category, String id) async {
    return await _firestore
        .collection('ShoppingLists') 
        .doc(userId) 
        .collection(category) 
        .doc(id) 
        .update({'Yes': true});
  }

  // Remover toda a lista de compras (subcoleção da categoria)
  Future<void> deleteProductList(String category) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection('ShoppingLists')
        .doc(userId)
        .collection(category);

    final querySnapshot = await collectionRef.get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

