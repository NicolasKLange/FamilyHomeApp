import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../assets/components/image_style/square_tile.dart';
import '../../assets/components/text_fields/text_fields_login.dart';
import '../../assets/components/buttons/button_login.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controladores
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isloading = false;

  //Método sign in usuário com email e senha
  signUserUp() async {
    setState(() {
      isloading = true;
    });
    //Circulo de carregando
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Verificação de email e senha de login
    // Try criar usuário
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // Pop circulo carregando
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop circulo carregando
      Navigator.pop(context);
      // Email errado
      showErrorMessage(e.code);
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
    setState(() {
      isloading = true;
    });
  }

  // Mensagem de erro de email popup
  void showErrorMessage(String Message) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.blue,
          title: Text(
            'Verifique email ou senha',
            style: TextStyle(color: Colors.white),
          ),
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
          //Permitir o scroll da página
          child: SingleChildScrollView(
            child: Column(
              //Alinhar ao centro da página
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                //Icon principal
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(
                  height: 25,
                ),
                //Texto de criar nova conta
                Text(
                  "Vamos criar uma conta para você!",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                //TextFields para nome
                Textfields(
                  controller: emailController,
                  hintText: "Nome",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
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
                //TextFields para Confirmar senha
                Textfields(
                  controller: passwordController,
                  hintText: "Confirmar senha",
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
                //Sign up button
                Button_login(
                  text: "Sign Up",
                  onTap: signUserUp,
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
                //Já possui conta? Faça login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já possui uma conta?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Faça Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
