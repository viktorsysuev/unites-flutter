import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/domain/repository/user_repository.dart';

@singleton
@injectable
class UserRepositoryImpl implements UserRepository {
  final db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserModel currentUser;

  @override
  Future<bool> isUserExist() async {
    final user = await auth.currentUser;
    final doc = await db.collection('users').doc(user!.uid).get();
    return doc.exists;
  }

  @override
  void createNewUser(UserModel user) async {
    var currentUser = await auth.currentUser;
    user.userId = currentUser!.uid;
    user.phone = currentUser.phoneNumber!;
    await db.collection('users').doc(user.userId).set(user.toJson());
  }

  @override
  void updateUser(UserModel user) async {
    var userId = await getCurrentUserId();
    user.userId = userId;
    await DatabaseProvider.db.insertData('users', user.toJson());
    await db.collection('users').doc(userId).update(user.toJson());
  }

  @override
  Future<UserModel> getUser(String userId) async {
    var user = await DatabaseProvider.db.getUser(userId);
    return user;
  }

  @override
  Future<User> getCurrentFirebaseUser() async {
    return auth.currentUser!;
  }

  @override
  Future<String> getCurrentUserId() async {
    var user = await auth.currentUser;
    currentUser = await getUser(user!.uid);
    return user.uid;
  }

  @override
  void logout() async {
    await auth.signOut();
  }

  @override
  UserModel getCurrentUser() {
    return currentUser;
  }
}
