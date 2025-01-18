import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth
      .instance.currentUser!.uid; // Obtém o UID do usuário autenticado

  // Inicializar o perfil do usuário
  Future<void> initializeUserProfile(String email) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': email,
        'cpf': null,
        'birthdate': null,
        'profileImageUrl': null, // Adicionar o campo da foto de perfil
      });
    }
  }

  // Atualizar informações do perfil do usuário
  Future<void> updateUserProfile(
      String name, String? cpf, String? birthdate) async {
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
}
