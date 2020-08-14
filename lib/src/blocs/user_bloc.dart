import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';


@injectable
class UsersBloc {
  var userRepository = getIt<UserRepository>();

  final _userFetcher = PublishSubject<UserModel>();
  final _contactsFetcher = PublishSubject<List<UserModel>>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  Stream<List<UserModel>> get getContacts => _contactsFetcher.stream;

  initUsers() {
    var firestoreDB = Firestore.instance;
    firestoreDB.collection('users').getDocuments().then((value) => {
      value.documents.forEach((element) {
        DatabaseProvider.db.insertData('users', element.data);
      }),
    });
  }

  fetchCurrentUser() async {
    var userId = await userRepository.getCurrentUserId();
    var user = await userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  getUserById(String userId) async {
    var user = await userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  fetchContacts() async {
    var userId = await userRepository.getCurrentUserId();
    var contacts = await DatabaseProvider.db.getContacts(userId);
    _contactsFetcher.sink.add(contacts);
  }

  dispose() {
    _userFetcher.close();
  }
}
