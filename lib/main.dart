// ignore_for_file: use_build_context_synchronously

import 'package:findit_app/controllers/auth_service.dart';
import 'package:findit_app/firebase_options.dart';
import 'package:findit_app/views/home_nav_bar.dart';
import 'package:findit_app/views/login_page.dart';
import 'package:findit_app/views/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    routes: {
      "/":(context)=> const CheckUserLoggedIn(),
      "/home":(context)=> const HomeNavBar(),
      "/login":(context)=> const LoginPage(),
      "/signUp":(context)=> const SignUpPage(),
    },
    );
  }
}

class CheckUserLoggedIn extends StatefulWidget {
  const CheckUserLoggedIn({super.key});

  @override
  State<CheckUserLoggedIn> createState() => _CheckUserLoggedInState();
}

class _CheckUserLoggedInState extends State<CheckUserLoggedIn> {
  @override
  void initState() {
    super.initState();
    AuthService().isLoggedIn().then(
      (value) {
        if (value) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }, 
    );
  } 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

