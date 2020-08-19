import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/user_model.dart';

@singleton
@injectable
class UserRepository {
  final db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel currentUser;

  Future<bool> isUserExist() async {
    final user = await auth.currentUser();
    final doc = await db.collection('users').document(user.uid).get();
    return doc.exists;
  }

  void createNewUser(UserModel user) async {
    var currentUser = await auth.currentUser();
    user.userId = currentUser.uid;
    user.phone = currentUser.phoneNumber;
    await db.collection('users').document(user.userId).setData(user.toJson());
  }

  void updateUser(UserModel user) async {
    var userId = await getCurrentUserId();
    user.userId = userId;
    await DatabaseProvider.db.insertData('users', user.toJson());
    await db
        .collection('users')
        .document(userId)
        .updateData(user.toJson());
  }

  Future<UserModel> getUser(String userId) async {
    var user = await DatabaseProvider.db.getUser(userId);
    return user;
  }

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    return await auth.currentUser();
  }

  Future<String> getCurrentUserId() async {
    var user = await auth.currentUser();
    currentUser = await getUser(user.uid);
    return user.uid;
  }

  void logout() async {
    await auth.signOut();
  }
}
