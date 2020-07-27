import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class UsersBloc {
  final _userRepository = UserRepository();
  final _userFetcher = PublishSubject<UserModel>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  initUsers() {
    var firestoreDB = Firestore.instance;
    firestoreDB.collection('users').getDocuments().then((value) => {
          value.documents.forEach((element) {
            DatabaseProvider.db.insertData('users', element.data);
          }),
        });
  }

  fetchCurrentUser() async {
    var userId = await _userRepository.getCurrentUserId();
    var user = await _userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  getUserById(String userId) async {
    var user = await _userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  dispose() {
    _userFetcher.close();
  }
}
