import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/src/models/UserModel.dart';

class UserRepository {
  final db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  Future<bool> isUserExist() async {
    final user = await auth.currentUser();
    final doc = await db.collection('users')
        .document(user.uid)
        .get();
    return doc.exists;
  }

  Future<UserModel> createNewUser(UserModel user) async {
    var currentUser = await auth.currentUser();
    user.id = currentUser.uid;
    db.collection('users').document(user.id).setData(user.toJson());
  }

  Future<UserModel> updateUser(UserModel user) async {
    db.collection('users').document(user.id).updateData(user.toJson());
  }

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    return await auth.currentUser();
  }
}
