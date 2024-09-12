import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  String name = "User";
  String email = "User";
  String address = "User";
  String phone = "User";

  UserProvider(){
    loadUserData();
  }

  //load user profile data
  void loadUserData(){
    _userSubscription?.cancel();
    _userSubscription = DbService().readUserData().listen((snapshot) {
      debugPrint("User data => $snapshot");
      final UserModel data = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      notifyListeners(); 
    },);
  }
}