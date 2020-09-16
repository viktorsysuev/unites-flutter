



import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/domain/models/user_model.dart';

abstract class UserRepository {

  Future<bool> isUserExist();

  void createNewUser(UserModel user);

  UserModel getCurrentUser();

  void updateUser(UserModel user);

  Future<UserModel> getUser(String userId);

  Future<FirebaseUser> getCurrentFirebaseUser();

  Future<String> getCurrentUserId();

  void logout();
}