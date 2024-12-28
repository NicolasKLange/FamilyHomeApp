import 'package:family_home_app/pages/services/supermarket/supermarket.dart';
import 'package:family_home_app/testeFirebase/listEmployee.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login/auth_page.dart';
import 'package:get/get.dart';

import 'testeToDoList/homeToDoList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Family Home',
      initialRoute: 'authPage',
      routes: {
        'authPage': (context) => const AuthPage(),
        '/listEmployes': (context) => const ListEmployee(),
        '/supermarket': (context) => const Supermarket(),
        '/toDoList': (context) => const HomeToDoList(),
      },
    );
  }
}