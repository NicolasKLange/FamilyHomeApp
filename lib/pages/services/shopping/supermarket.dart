import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'databaseShopping/database.dart';

class Supermarket extends StatefulWidget {
  const Supermarket({super.key});

  @override
  State<Supermarket> createState() => _SupermarketState();
}

class _SupermarketState extends State<Supermarket> {
  bool supermarket = true, pharmacy = false, clothes = false, school = false;
  bool suggest = false;
  Stream? todoStream;
  final user = FirebaseAuth.instance.currentUser!;

  getontheload() async {
    todoStream = await ShoppingDatabaseMethods().getalltheProducts(supermarket
        ? 'Supermarket'
        : pharmacy
            ? 'Pharmacy'
            : clothes
                ? 'Clothes'
                : 'School');
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
                  color: const Color(0xFFEDE8E8).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2B3649),
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return CheckboxListTile(
                        activeColor: const Color(0xFF279CFB),
                        title: Text(
                          ds['Product'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        value: ds['Yes'],
                        onChanged: (newValue) async {
                          await ShoppingDatabaseMethods().updateifTicked(
                              ds['Id'],
                              supermarket
                                  ? 'Supermarket'
                                  : pharmacy
                                      ? 'Pharmacy'
                                      : clothes
                                          ? 'Clothes'
                                          : 'School');
                          setState(() {});
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
              )
            : const CircularProgressIndicator();
      },
    );
  }

  TextEditingController todoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Botao para adicionar produto
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF249FFF),
          size: 30.0,
        ),
      ),
      backgroundColor: const Color(0xFFA8BEE0),
      //AppBar com logo e email do login
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Lista',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B3649),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Lista das compras
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Supermarket
                  supermarket
                      ? Material(
                          //Colocar uma sombra
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3DFFE3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Supermarket',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            supermarket = true;
                            pharmacy = false;
                            clothes = false;
                            school = false;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            'Supermarket',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                  //Pharmacy
                  pharmacy
                      ? Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3DFFE3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pharmacy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            supermarket = false;
                            pharmacy = true;
                            clothes = false;
                            school = false;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            'Pharmacy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                  //Clothes
                  clothes
                      ? Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3DFFE3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Clothes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            supermarket = false;
                            pharmacy = false;
                            clothes = true;
                            school = false;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            'Clothes',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                  //School
                  school
                      ? Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3DFFE3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'School',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            supermarket = false;
                            pharmacy = false;
                            clothes = false;
                            school = true;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            'School',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
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
                          child: const Icon(Icons.cancel),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        const Text(
                          'Adicionar Tarefa',
                          style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Descrição',
                      style: TextStyle(
                          color: Color(0xFF008080),
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
                        supermarket
                            ? ShoppingDatabaseMethods()
                                .addSupermarketProduct(userTodo, id)
                            : pharmacy
                                ? ShoppingDatabaseMethods()
                                    .addPharmacyProduct(userTodo, id)
                                : clothes
                                    ? ShoppingDatabaseMethods()
                                        .addClothesProduct(userTodo, id)
                                    : ShoppingDatabaseMethods()
                                        .addClothesProduct(userTodo, id);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                              child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
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
