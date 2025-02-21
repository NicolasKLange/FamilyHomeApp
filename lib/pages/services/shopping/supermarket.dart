import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import '../../../database/database.dart';

class Supermarket extends StatefulWidget {
  const Supermarket({super.key});

  @override
  State<Supermarket> createState() => _SupermarketState();
}

class _SupermarketState extends State<Supermarket> {
  Stream? todoStream;
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final String category = "Supermarket"; // Define a categoria

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  void getOnTheLoad() async {
    String? familyId = await _databaseMethods.getFamilyId();
    if (familyId != null) {
      setState(() {
        todoStream = _databaseMethods.getProducts(familyId, "Supermarket");
      });
    }
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
                            'Lista de Compras',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF2B3649),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              // Ícone de adicionar produto
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF2B3649),
                                ),
                                onPressed: openBox,
                              ),
                              // Três pontinhos
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors
                                        .transparent, // Fundo transparente
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
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                      "Confirmar Exclusão",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF2B3649),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFFEDE8E8),
                                                    content: const Text(
                                                      "Você realmente deseja excluir esta lista?",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF2B3649),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Fecha o diálogo
                                                        },
                                                        child: const Text(
                                                          "Cancelar",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF2B3649),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          String? familyId =
                                                              await DatabaseMethods()
                                                                  .getFamilyId(); // Obtém o familyId

                                                          if (familyId !=
                                                              null) {
                                                            await DatabaseMethods()
                                                                .deleteProductList(
                                                                    familyId,
                                                                    category);
                                                            setState(() {
                                                              todoStream =
                                                                  null; // Limpa a lista após a exclusão
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Fecha o diálogo
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Fecha o menu
                                                          } else {
                                                            // Se não encontrar o familyId, exibe uma mensagem de erro
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Erro: Nenhuma família encontrada para este usuário.')),
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFF577096),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Text(
                                                            'Excluir',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFEDE8E8),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  border: Border.all(
                                                      color: Colors.red),
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                              String? familyId = await DatabaseMethods()
                                  .getFamilyId(); // Obtém o familyId

                              if (familyId != null) {
                                await DatabaseMethods().updateIfTicked(
                                    familyId, category, ds['Id']);
                                setState(() {});
                              } else {
                                // Se não encontrar o familyId, exibe uma mensagem de erro
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Erro: Nenhuma família encontrada para este usuário.')),
                                );
                              }
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

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<DocumentSnapshot> get userStream {
    return DatabaseMethods().getUserProfile(userId).asStream();
  }

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BEE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        title: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userName = snapshot.data!['name'] ?? 'Usuário';
              return Row(
                children: [
                  Image.asset('lib/assets/images/logoApp.png', height: 40),
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
                    icon: const Icon(Icons.logout, color: Color(0xffEDE8E8)),
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
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<String?>(
        future: DatabaseMethods().getFamilyId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(
                      right: 43, left: 43, top: 30, bottom: 10),
                  padding: const EdgeInsets.only(bottom: 5, top: 5, left: 20),
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        category,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 300,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Você não pertence a uma família"),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/homePage');
                        },
                        child: const Text(
                          "Toque aqui para voltar e criar uma família",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3649),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2B3649), width: 2),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B3649),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(child: allProduct()),
            ],
          );
        },
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adicionar Produto',
                        style: TextStyle(
                            color: Color(0xFF2B3649),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Color(0xFF577096),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: todoController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Produto'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      if (todoController.text.isEmpty) {
                        // Mostrar mensagem de erro ou alertar o usuário
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Por favor, insira um produto.')),
                        );
                      } else {
                        String? familyId = await DatabaseMethods()
                            .getFamilyId(); // Obtém o familyId

                        if (familyId != null) {
                          String id = randomAlphaNumeric(10);
                          Map<String, dynamic> userTodo = {
                            'Product': todoController.text,
                            'Id': id,
                            'Yes': false,
                          };

                          await DatabaseMethods()
                              .addProduct(familyId, category, userTodo, id);
                          Navigator.pop(context);
                        } else {
                          // Se o usuário não estiver em uma família, exibe uma mensagem de erro
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Erro: Nenhuma família encontrada para este usuário.')),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 130.0),
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
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  void addProduct(String productName) async {
    String? familyId = await _databaseMethods.getFamilyId();
    if (familyId != null) {
      String id = randomAlphaNumeric(10); // Gerando um ID único para o produto
      Map<String, dynamic> productData = {
        "Product": productName,
        "Yes": false,
        "Id": id
      };
      await _databaseMethods.addProduct(
          familyId, "Supermarket", productData, id);
    }
  }

  void deleteShoppingList() async {
    String? familyId = await _databaseMethods.getFamilyId();
    if (familyId != null) {
      await _databaseMethods.deleteProductList(familyId, "Supermarket");
      setState(() {
        todoStream = null; // Limpa a UI após excluir a lista
      });
    }
  }
}
