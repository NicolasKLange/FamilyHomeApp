import 'package:family_home_app/pages/family/family.dart';
import 'package:family_home_app/pages/home/home_page.dart';
import 'package:family_home_app/pages/services/shopping/clothes.dart';
import 'package:family_home_app/pages/services/shopping/dashboardShopping.dart';
import 'package:family_home_app/pages/services/shopping/pharmacy.dart';
import 'package:family_home_app/pages/services/shopping/school.dart';
import 'package:family_home_app/pages/services/tasksList/tasksList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'pages/login/auth_page.dart';
import 'package:get/get.dart';
import 'pages/services/shopping/supermarket.dart';
import 'testeToDoList/homeToDoList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('pt_BR', null);
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
        '/shopping': (context) => const Shopping(),
        '/toDoList': (context) => const HomeToDoList(),
        '/tasksList': (context) =>  const TasksList(),
        '/homePage': (context) => const HomePage(),
        '/supermarket': (context) => const Supermarket(),
        '/pharmacy': (context) => const Pharmacy(),
        '/clothes': (context) => const Clothes(),
        '/school': (context) => const School(),
        '/family': (context) => const FamilyScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    supportedLocales: const [Locale('pt', 'BR')],
    
    );
  }
}