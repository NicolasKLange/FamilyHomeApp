import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
    signInWithGoogle() async{
      // Começo do sign in com google, capturar o usuário
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Obter os detalhes dados
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Criar uma nova credencial para o usuário
      final credential = GoogleAuthProvider.credential(
        // Token
        accessToken: gAuth.accessToken,
        // id Token
        idToken: gAuth.idToken,
      );

      // Finalizando sign in com método do Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
}