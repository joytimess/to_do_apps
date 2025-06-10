import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_to_do_apps/auth_layout.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'navigations/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      initialRoute: '/login',
      home: AuthLayout(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainNavigation(),
        '/tasks': (context) => MainNavigation(),
        '/addNewTask': (context) => MainNavigation(),
        '/listTasks': (context) => MainNavigation(),
        '/profilePage': (context) => MainNavigation(),
      },
    ),
  );
}
