import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> logIn({String email, String password});
  Future<String> signUp({String email, String password});
  Future<void> sigOut();
  Future<FirebaseUser> currentUser();
  Future<DocumentSnapshot> userInfo();
}

class Auth implements BaseAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> logIn({String email, String password}) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  @override
  Future<String> signUp({String email, String password}) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user?.uid;
  }

  @override
  Future<FirebaseUser> currentUser() async => await _auth.currentUser();

  @override
  Future<void> sigOut() async => _auth.signOut();

  @override
  Future<DocumentSnapshot> userInfo() async {
    Firestore db = Firestore.instance;
    FirebaseUser firebaseUser = await currentUser();

   return await db.collection('users').document(firebaseUser.uid).get();
  }
}
