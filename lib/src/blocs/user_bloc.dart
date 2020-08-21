import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:unites_flutter/src/resources/story_repository.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';

@injectable
class UsersBloc {
  var userRepository = getIt<UserRepository>();
  var storyRepository = getIt<StoryRepository>();

  final _userFetcher = PublishSubject<UserModel>();
  final _contactsFetcher = PublishSubject<List<UserModel>>();
  final _contactsWithStoryFetcher = PublishSubject<List<UserModel>>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  Stream<List<UserModel>> get getContacts => _contactsFetcher.stream;

  Stream<List<UserModel>> get getContactsWithStory => _contactsWithStoryFetcher.stream;

  initUsers() async{
    var firestoreDB = Firestore.instance;
    storyRepository.initStories();
    await firestoreDB.collection('users').getDocuments().then((value) => {
      value.documents.forEach((element) {
        DatabaseProvider.db.insertData('users', element.data);
      }),
    });

    await userRepository.getCurrentUserId();
  }

  fetchCurrentUser() async {
    var userId = userRepository.currentUser.userId;
    var user = await userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  getUserById(String userId) async {
    var user = await userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  fetchContacts() async {
    var currentUserId;
    var contacts = <UserModel>[];
    if(userRepository.currentUser != null){
      currentUserId = userRepository.currentUser.userId;
      contacts = await DatabaseProvider.db.getContacts(currentUserId);
    }
    _contactsFetcher.sink.add(contacts);
  }

  fetchContactsWithStory() async {
    var contacts = await DatabaseProvider.db.getContactsWithStory();
    _contactsWithStoryFetcher.sink.add(contacts);
  }

  dispose() {
    _userFetcher.close();
  }
}
