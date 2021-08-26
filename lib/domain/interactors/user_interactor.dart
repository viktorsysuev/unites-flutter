import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/domain/repository/user_repository.dart';

@injectable
class UserInteractor {
  UserInteractor(this.userRepository);

  UserRepository userRepository;

  Future<bool> isUserExist() {
    return userRepository.isUserExist();
  }

  UserModel? getCurrentUser() {
    return userRepository.getCurrentUser();
  }

  void createNewUser(UserModel user) {
    userRepository.createNewUser(user);
  }

  void updateUser(UserModel user) {
    userRepository.updateUser(user);
  }

  Future<UserModel> getUser(String userId) {
    return userRepository.getUser(userId);
  }

  Future<User> getCurrentFirebaseUser() {
    return userRepository.getCurrentFirebaseUser();
  }

  Future<String> getCurrentUserId() {
    return userRepository.getCurrentUserId();
  }

  void logout() {
    userRepository.logout();
  }
}
