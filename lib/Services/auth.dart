import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:test_project_uber_clone/Models/user_models.dart';

class AuthServices {
//firebase instance

  final FirebaseAuth _auth = FirebaseAuth.instance;

//Create a user from firebase user with uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

//create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //SignUp using details
  Future registerWithDetails(String email, String password, String username,
      String phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users").child(user!.uid);
      Map userDataMap = {
        "name": username,
        "phone": phoneNumber,
        "id": user!.uid,
        "blockStatus": "no"
      };
      usersRef.set(userDataMap);
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print('----------------------------' + err.toString());
      return null;
    }
  }

  // Future addUserDetails(String phoneNumber,String username)async{

  // }

  //login using email and password
  Future loginUsingEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //  return _userWithFirebaseUserUid(user);
      return user;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //Sign in anonymous
  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

//log out
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return Null;
    }
  }
}
