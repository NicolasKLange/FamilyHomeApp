import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../assets/components/image_style/square_tile.dart';
import '../../assets/components/text_fields/text_fields_login.dart';
import '../../assets/components/buttons/button_login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controladores
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Método sign in usuário com email e senha
  //Método sign in usuário com email e senha
  void signUserIn() async {
    //Circulo de carregando
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // pop circulo carregando
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop circulo carregando
      Navigator.pop(context);
      // email errado
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      }
      // senha errada
      else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  // Mensagem de erro de email popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Email incorreto'),
        );
      },
    );
  }

  // Mensagem de erro de senha popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Senha incorreta'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            //Alinhar ao centro da página
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              //Icon principal
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(
                height: 50,
              ),
              //Texto de boas vindas
              Text(
                "Bem vindo de volta",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(
                height: 25,
              ),
              //TextFields para email
              Textfields(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              //TextFields para senha
              Textfields(
                controller: passwordController,
                hintText: "Senha",
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              //Esqueceu a senha
              Padding(
                //Deixar com margem do lado
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  //Desixar no fim da linha
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Esqueceu a senha?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Sign in button
              Button_login(
                onTap: signUserIn,
              ),

              const SizedBox(
                height: 25,
              ),
              //Divisor (linha para separar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    //Texto entre os divisores
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Ou tente fazer login com",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //SignIn com google
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/assets/images/signInGoogle.png'),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              //Não possui conta? Registre-se
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Não tem conta?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Registre-se",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
