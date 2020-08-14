import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/injection.config.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/models/message_model.dart';
import 'package:unites_flutter/src/resources/chat_repository.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';


@injectable
class ChatsBloc {

  var chatRepository = getIt<ChatRepository>();

  var userRepository = getIt<UserRepository>();

  final _messageFetcher = PublishSubject<List<MessageModel>>();

  Stream<List<MessageModel>> get getMessages => _messageFetcher.stream;

  void sendNewMessage(String userId, String text) {
    chatRepository.sendMessage(userId, text);
  }

  void fetchAllMessages(String userId) async {
    var messages = await chatRepository.getChatMessages(userId);
    _messageFetcher.sink.add(messages);
  }

  void addMessagesListener(String userId) async {
    var currentUserId = await userRepository.getCurrentUserId();
    var firestoreDB = Firestore.instance;
    var user = await firestoreDB.collection('users').document(currentUserId);
    await user
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .getDocuments()
        .then((value) => {
              value.documents[0].reference
                  .collection('messages')
                  .snapshots()
                  .listen((event) {
                event.documentChanges.forEach((element) {
                  print('changes ${element.type}');
                  fetchAllMessages(userId);
                });
              })
            });
  }
}
