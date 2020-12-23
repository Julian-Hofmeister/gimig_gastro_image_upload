import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final _firestore = FirebaseFirestore.instance;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password, context}) async {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("SignIn Successful");

      Navigator.pushReplacementNamed(context, AuthenticationWrapper.id);

      return "SignIn Successful";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }

  Future<String> signUp(
      {String email, String password, context, String name}) async {
    try {
      _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("SignUp Successful");

      await _firestore
          .collection("restaurants")
          .doc("$email")
          .set({"name": name});

      print(name);

      Navigator.pushReplacementNamed(context, AuthenticationWrapper.id);

      return "SignUp Successful";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> currentUser() async {
    try {
      User currentUser = _firebaseAuth.currentUser;
      return currentUser;
    } on FirebaseAuthException catch (e) {
      signOut();
      print(e);
      return null;
    }
  }
}
