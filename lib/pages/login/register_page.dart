import 'package:family_home_app/servicesAuth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Variáveis para mostrar/ocultar senha
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isloading = false;

// Método sign in usuário com email e senha
signUserUp() async {
  // Circulo de carregando
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  // Verificação de senha
  try {
    // Verificar se a senha possui no mínimo 6 caracteres
    if (passwordController.text.length < 6) {
      Navigator.pop(context); // Fechar o carregando antes do erro
      showErrorMessage('A senha deve ter no mínimo 6 caracteres');
      return;
    }
    
    // Verificar se as senhas coincidem
    if (passwordController.text == confirmPasswordController.text) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );
      Navigator.pop(context); // Fechar o carregando apenas se bem-sucedido
    } else {
      Navigator.pop(context); // Fechar o carregando antes do erro
      showErrorMessage('Senhas não coincidem');
    }
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Fechar o carregando em caso de erro
    showErrorMessage(e.message ?? 'Erro desconhecido');
  } catch (e) {
    Navigator.pop(context); // Fechar o carregando em caso de erro genérico
    showErrorMessage(e.toString());
  }
}



  // Mensagem de erro de email popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
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
                const SizedBox(height: 25),
                //Icon principal
                Image.asset(
                  'lib/assets/images/logoApp.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 25,
                ),
                //Texto de criar nova conta
                const Text(
                  "Vamos criar uma conta para você!",
                  style: TextStyle(color: Color(0xFFEDE8E8), fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 25,
                ),
                // //TextFields para nome
                // Textfields(
                //   controller: nameController,
                //   hintText: "Nome",
                //   obscureText: false,
                // ),
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
                  controller: confirmPasswordController,
                  hintText: "Confirmar senha",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                
                const SizedBox(
                  height: 25,
                ),
                //Sign up buttonR
                ButtonLogin(
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Ou tente fazer login com",
                          style: TextStyle(
                            color: Color(0xFFEDE8E8), fontSize: 15,
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
                //Já possui conta? Faça login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Já possui uma conta?",
                      style: TextStyle(
                        color: Color(0xFFEDE8E8),fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Faça Login",
                        style: TextStyle(
                           color: Color(0xFFEDE8E8), fontWeight: FontWeight.bold, fontSize: 16),
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