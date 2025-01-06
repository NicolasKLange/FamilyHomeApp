import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                            onTap: () async {
                              await ShoppingDatabaseMethods()
                                  .deleteProductList(category);
                              setState(() {
                                todoStream =
                                    null; // Limpa a lista após a exclusão
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Lista de compras excluída com sucesso!')),
                              );
                            },
                            child: const Icon(
                              Icons.cancel,
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

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        backgroundColor: const Color(0xFF577096),
        child: const Icon(
          Icons.add,
          color: Color(0xFFEDE8E8),
          size: 30.0,
        ),
      ),
      backgroundColor: const Color(0xFFA8BEE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF577096),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logoApp.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              user.email!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFEDE8E8),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
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
