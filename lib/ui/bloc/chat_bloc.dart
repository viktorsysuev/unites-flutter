import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/domain/interactors/chat_interactor.dart';
import 'package:unites_flutter/domain/interactors/user_interactor.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/domain/models/message_model.dart';

@injectable
class ChatsBloc {
  var chatInteractor = getIt<ChatInteractor>();

  var userInteractor = getIt<UserInteractor>();

  final _messageFetcher = PublishSubject<List<MessageModel>>();

  Stream<List<MessageModel>> get getMessages => _messageFetcher.stream;

  void sendNewMessage(String userId, String text) {
    chatInteractor.sendMessage(userId, text);
  }

  void fetchAllMessages(String userId) async {
    var messages = await chatInteractor.getChatMessages(userId);
    _messageFetcher.sink.add(messages);
  }

  void addMessagesListener(String userId) async {
    var currentUserId = await userInteractor.getCurrentUserId();
    var firestoreDB = FirebaseFirestore.instance;
    var user = firestoreDB.collection('users').doc(currentUserId);
    await user
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .get()
        .then((value) => {
              value.docs[0].reference
                  .collection('messages')
                  .snapshots()
                  .listen((event) {
                event.docChanges.forEach((element) {
                  print('changes ${element.type}');
                  fetchAllMessages(userId);
                });
              })
            });
  }
}
