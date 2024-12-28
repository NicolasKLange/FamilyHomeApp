import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_home_app/testeToDoList/services/databaseToDoList.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class HomeToDoList extends StatefulWidget {
  const HomeToDoList({super.key});

  @override
  State<HomeToDoList> createState() => _HomeToDoListState();
}

class _HomeToDoListState extends State<HomeToDoList> {
  bool today = true, tomorrow = false, nextWeek = false;
  bool suggest = false;
  Stream? todoStream;

  getontheload() async {
    todoStream = await DatabaseMethods().getalltheWork(today
        ? 'Today'
        : tomorrow
            ? 'Tomorrow'
            : 'NextWeek');
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return CheckboxListTile(
                      activeColor: const Color(0xFF279CFB),
                      title: Text(
                        ds['Work'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      value: ds['Yes'],
                      onChanged: (newValue) async {
                        await DatabaseMethods().updateifTicked(
                            ds['Id'],
                            today
                                ? 'Today'
                                : tomorrow
                                    ? 'Tomorrow'
                                    : 'NextWeek');
                        setState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  })
              : const CircularProgressIndicator();
        });
  }

  TextEditingController todoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        padding: const EdgeInsets.only(top: 90.0, left: 30.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          //Fundo em gradient
          gradient: LinearGradient(colors: [
            // ignore: use_full_hex_values_for_flutter_colors
            Color(0xFF232FDA2),
            Color(0xFF13D8CA),
            Color(0xFF09ADFE),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
          // Botão de voltar
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
            //Texto de boas vindas
            const Text(
              'BEM VINDO\nNICOLAS LANGE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'Bom dia',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //Lista das semanas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                today
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
                            'Today',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = true;
                          tomorrow = false;
                          nextWeek = false;
                          await getontheload();
                          setState(() {});
                        },
                        child: const Text(
                          'Today',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                //Tomorrow
                tomorrow
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
                            'Tomorrow',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = false;
                          tomorrow = true;
                          nextWeek = false;
                          await getontheload();
                          setState(() {});
                        },
                        child: const Text(
                          'Tomorrow',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                //NextWeek
                nextWeek
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
                            'Next Week',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = false;
                          tomorrow = false;
                          nextWeek = true;
                          await getontheload();
                          setState(() {});
                        },
                        child: const Text(
                          'Next Week',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 20.0),
            allWork(),
          ],
        ),
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
                          'Work': todoController.text,
                          'Id': id,
                          'Yes': false,
                        };
                        today
                            ? DatabaseMethods().addTodayWork(userTodo, id)
                            : tomorrow
                                ? DatabaseMethods()
                                    .addTomorrowWork(userTodo, id)
                                : DatabaseMethods()
                                    .addNextWeekWork(userTodo, id);
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
