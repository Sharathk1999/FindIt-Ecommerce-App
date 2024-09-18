// ignore_for_file: use_build_context_synchronously

import 'package:findit_app/controllers/auth_service.dart';
import 'package:findit_app/firebase_options.dart';
import 'package:findit_app/providers/user_provider.dart';
import 'package:findit_app/views/discount_page.dart';
import 'package:findit_app/views/home_nav_bar.dart';
import 'package:findit_app/views/login_page.dart';
import 'package:findit_app/views/sign_up_page.dart';
import 'package:findit_app/views/specific_product_page.dart';
import 'package:findit_app/views/update_profile.dart';
import 'package:findit_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),)
      ],
      child: MaterialApp(
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
        "/update_profile":(context)=> const UpdateProfile (),
        "/discount":(context)=> const DiscountPage (),
        "/specific":(context)=> const SpecificProductPage (),
        "/view_product":(context)=> const ViewProduct (),
        
      },
      ),
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

