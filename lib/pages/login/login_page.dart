import 'package:family_home_app/servicesAuth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../assets/components/image_style/square_tile.dart';
import '../../assets/components/text_fields/text_fields_login.dart';
import '../../assets/components/buttons/button_login.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controladores
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isloading = false;

  //Método sign in usuário com email e senha
  signUserIn() async {
    setState(() {
      isloading = true;
    });
    //Circulo de carrega
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Verificação de email e senha de login
    // Try sign in
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

  // Mensagem de erro no topo da tela
  void showErrorMessage(String message) {
    Get.snackbar(
      'Erro de Login', // Título
      'Verifique seu email ou senha', // Mensagem
      backgroundColor: const  Color(0xFF2B3649),
      colorText: const Color(0xFFEDE8E8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF577096),
      body: SafeArea(
        child: Center(
          //Permitir o scroll da página
          child: SingleChildScrollView(
            child: Column(
              //Alinhar ao centro da página
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                //Icon principal
                Image.asset(
                  'lib/assets/images/logoApp.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 40,
                ),
                //Texto de boas vindas
                const Text(
                  "Bem vindo de volta",
                  style: TextStyle(
                      color: Color(0xFFEDE8E8),
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 30,
                ),
                //TextFields para email
                Textfields(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 13,
                ),
                //TextFields para senha
                Textfields(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 13,
                ),
                //Esqueceu a senha
                const Padding(
                  //Deixar com margem do lado
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    //Desixar no fim da linha
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Esqueceu a senha?",
                        style:
                            TextStyle(color: Color(0xFFEDE8E8), fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                //Sign in button
                ButtonLogin(
                  text: "Sign In",
                  onTap: signUserIn,
                ),
                const SizedBox(
                  height: 30,
                ),
                //Divisor (linha para separar)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFFEDE8E8),
                        ),
                      ),
                      //Texto entre os divisores
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Ou tente fazer login com ",
                          style: TextStyle(
                            color: Color(0xFFEDE8E8),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFFEDE8E8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                //SignIn com google
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/assets/images/signInGoogle.png'),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                //Não possui conta? Registre-se
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tem conta?",
                      style: TextStyle(
                        color: Color(0xFFEDE8E8),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Registre-se",
                        style: TextStyle(
                            color: Color(0xFFEDE8E8),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
