import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingDatabaseMethods {
  Future addSupermarketProduct(Map<String, dynamic> userShoppingMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Supermarket')
        .doc(id)
        .set(userShoppingMap);
  }

  Future addPharmacyProduct(Map<String, dynamic> userShoppingMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(id)
        .set(userShoppingMap);
  }

  Future addClothesProduct(Map<String, dynamic> userShoppingMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Clothes')
        .doc(id)
        .set(userShoppingMap);
  }

  Future addSchoolProduct(Map<String, dynamic> userShoppingMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('School')
        .doc(id)
        .set(userShoppingMap);
  }

  //Coletar os dados do firebaseCloud
  Future<Stream<QuerySnapshot>> getalltheProducts(String product) async {
    return await FirebaseFirestore.instance.collection(product).snapshots();
  }

  //Função para marcar na checkbox
  updateifTicked(String id, String product) async {
    return await FirebaseFirestore.instance
        .collection(product)
        .doc(id)
        .update({'Yes': true});
  }
}
