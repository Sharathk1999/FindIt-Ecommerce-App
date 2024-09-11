



import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  //create new account using email password method
  Future<String> createAccountWithEmail(String email, String password)async{
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    }on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //login with email and password
  Future<String> loginWithEmail(String email, String password)async{
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    }on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //logout
  Future logOut()async{
    await auth.signOut();
  }

  //resent the password
  Future resetPassword(String email)async{
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "Mail Sent";
    }on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
  
  //check user is logged in or not
  Future<bool> isLoggedIn()async{
    var user = auth.currentUser;
    return user != null;
  }
}