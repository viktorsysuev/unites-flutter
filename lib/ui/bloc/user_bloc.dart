import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/domain/interactors/user_interactor.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/data/repository/story_repository_impl.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

@injectable
class UsersBloc {
  var userInteractor = getIt<UserInteractor>();
  var storyInteractor = getIt<StoryRepositoryImpl>();

  final _userFetcher = PublishSubject<UserModel>();
  final _contactsFetcher = PublishSubject<List<UserModel>>();
  final _contactsWithStoryFetcher = PublishSubject<List<UserModel>>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  Stream<List<UserModel>> get getContacts => _contactsFetcher.stream;

  Stream<List<UserModel>> get getContactsWithStory => _contactsWithStoryFetcher.stream;

  initUsers() async{
    var firestoreDB = Firestore.instance;
    storyInteractor.initStories();
    await firestoreDB.collection('users').getDocuments().then((value) => {
      value.documents.forEach((element) {
        DatabaseProvider.db.insertData('users', element.data);
      }),
    });

    await userInteractor.getCurrentUserId();
  }

  fetchCurrentUser() async {
    var userId = userInteractor.getCurrentUser().userId;
    var user = await userInteractor.getUser(userId);
    _userFetcher.sink.add(user);
  }

  getUserById(String userId) async {
    var user = await userInteractor.getUser(userId);
    _userFetcher.sink.add(user);
  }

  fetchContacts() async {
    var currentUserId;
    var contacts = <UserModel>[];
    if(userInteractor.getCurrentUser() != null){
      currentUserId = userInteractor.getCurrentUser().userId;
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
