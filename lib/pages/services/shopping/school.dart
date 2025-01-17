import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'databaseShopping/database.dart';

class School extends StatefulWidget {
  const School({super.key});

  @override
  State<School> createState() => _SchoolState();
}

class _SchoolState extends State<School> {
  Stream? todoStream;
  final user = FirebaseAuth.instance.currentUser!;
  final String category = "School"; // Define a categoria

  getontheload() async {
    todoStream = await ShoppingDatabaseMethods().getProducts(category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

   Widget allProduct() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2B3649),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lista',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF2B3649),
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    Colors.transparent, // Fundo transparente
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Ícone de Cancelar
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Fecha o menu inferior
                                            },
                                          ),
                                        ),
                                        const Spacer(),
                                        // Botão de Excluir Lista
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Confirmar Exclusão"),
                                                content: const Text(
                                                    "Você realmente deseja excluir esta lista?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Fecha o diálogo
                                                    },
                                                    child:
                                                        const Text("Cancelar"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await ShoppingDatabaseMethods()
                                                          .deleteProductList(
                                                              category);
                                                      setState(() {
                                                        todoStream =
                                                            null; // Limpa a lista após a exclusão
                                                      });
                                                      Navigator.of(context)
                                                          .pop(); // Fecha o diálogo
                                                      Navigator.of(context)
                                                          .pop(); // Fecha o menu
                                                    },
                                                    child: const Text(
                                                      "Excluir",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              border:
                                                  Border.all(color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Excluir lista",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF2B3649),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return CheckboxListTile(
                            activeColor: const Color(0xFF577096),
                            title: Text(
                              ds['Product'],
                              style: const TextStyle(
                                  color: Color(0xFF2B3649),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            value: ds['Yes'],
                            onChanged: (newValue) async {
                              await ShoppingDatabaseMethods()
                                  .updateIfTicked(category, ds['Id']);
                              setState(() {});
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }),
                  ],
                ),
              )
            : const CircularProgressIndicator();
      },
    );
  }

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
  }
  
  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
      // AppBar com logo e nome do usuário
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        title: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userName = snapshot.data!['name'] ?? 'Usuário';
              return Row(
                children: [
                  Image.asset(
                    'lib/assets/images/logoApp.png',
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEDE8E8),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xffEDE8E8),
                    ),
                    onPressed: () => _showOptionsModal(context),
                  ),
                ],
              );
            }
            return const Text(
              'Carregando...',
              style: TextStyle(fontSize: 16, color: Color(0xFFEDE8E8)),
            );
          },
        ),
        automaticallyImplyLeading:
            false, // Remove o botão de voltar automaticamente
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
                right: 30, left: 30, top: 30, bottom: 10),
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2B3649),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 60.0,
                ),
                const Text(
                  'Escola',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3649),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              allProduct(),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0XFFEDE8E8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Color(0xFF2B3649)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: forgetAccountWithGoogle,
                icon: const Icon(Icons.email, color: Colors.red),
                label: const Text(
                  'Esquecer e-mail cadastrado',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: signUserOutWithEmailAndPassword,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void signUserOutWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'authPage');
  }

  void forgetAccountWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'authPage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao deslogar: $e"),
        ),
      );
    }
  }
  
  Future openBox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Color(0xFF577096),
                          ),
                        ),
                        const SizedBox(
                          width: 25.0,
                        ),
                        const Text(
                          'Adicionar Produto',
                          style: TextStyle(
                              color: Color(0xFF2B3649),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Descrição',
                      style: TextStyle(
                          color: Color(0xFF2B3649),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Incluir'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        String id = randomAlphaNumeric(10);
                        Map<String, dynamic> userTodo = {
                          'Product': todoController.text,
                          'Id': id,
                          'Yes': false,
                        };
                        ShoppingDatabaseMethods()
                            .addProduct(category, userTodo, id);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF577096),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                              child: Text(
                            'Adicionar',
                            style: TextStyle(
                                color: Color(0xFFEDE8E8),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
