import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  //User Data
  //Add user to DB
  Future saveUserData({
    required String name,
    required String email,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };
      debugPrint("Saving $data");
      await db.collection("shop_users").doc(user!.uid).set(data);
    } catch (e) {
      debugPrint("From DbService => Error on saving user data: $e");
    }
  }

  //Update user data
  Future updateUserData({
    required Map<String, dynamic> extraData,
  }) async {
    await db.collection("shop_users").doc(user!.uid).update(extraData);
  }

  //Read the user data
  Stream<DocumentSnapshot> readUserData(){
   return db.collection("shop_users").doc(user!.uid).snapshots();
  }

  //Read all the promos and banners
  Stream<QuerySnapshot> readPromos(){
    return db.collection("shop_promos").snapshots();
  }
  Stream<QuerySnapshot> readBanners(){
    return db.collection("shop_banners").snapshots();
  }
}
 