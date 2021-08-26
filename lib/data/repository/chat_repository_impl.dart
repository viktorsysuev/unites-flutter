import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/repository/chat_repository.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/domain/models/chat_model.dart';
import 'package:unites_flutter/domain/models/message_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

@injectable
class ChatRepositoryImpl implements ChatRepository {
  final db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var userRepository = getIt<UserRepositoryImpl>();

  @override
  void startNewChat(String userId, String text) async {
    var currentUserId = await userRepository.getCurrentUserId();

    var newMessage = MessageModel();
    newMessage.createdAt = DateTime.now();
    newMessage.isMine = true;
    newMessage.text = text;

    var newClientMessage = MessageModel();
    newClientMessage.createdAt = DateTime.now();
    newClientMessage.isMine = false;
    newClientMessage.text = text;

    var newChat = ChatModel();
    newChat.chatWith = userId;

    var newClientChat = ChatModel();
    newClientChat.chatWith = currentUserId;

    await db
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .add(newChat.toJson())
        .then((value) => {
              newChat.chatId = value.id,
              db
                  .collection('users')
                  .doc(currentUserId)
                  .collection('chats')
                  .doc(value.id)
                  .update(newChat.toJson())
                  .whenComplete(() => {
                        newMessage.chatId = value.id,
                        value
                            .collection('messages')
                            .add(newMessage.toJson())
                            .then((value) => {
                                  newMessage.messageId = value.id,
                                  value.update(newMessage.toJson())
                                })
                      })
            });

    await db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .add(newClientChat.toJson())
        .then((value) => {
              newClientChat.chatId = value.id,
              db
                  .collection('users')
                  .doc(userId)
                  .collection('chats')
                  .doc(value.id)
                  .update(newClientChat.toJson())
                  .whenComplete(() => {
                        newClientMessage.chatId = value.id,
                        value
                            .collection('messages')
                            .add(newClientMessage.toJson())
                            .then((value) => {
                                  newClientMessage.messageId = value.id,
                                  value.update(newClientMessage.toJson())
                                })
                      })
            });
  }

  @override
  Future<List<MessageModel>> getChatMessages(String userId) async {
    var messages = <MessageModel>[];
    var currentUserId = await userRepository.getCurrentUserId();
    var chat = await db
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .get();

    if (chat.docs.isNotEmpty) {
      await chat.docs[0].reference
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  messages.add(MessageModel.fromJson(element.data()));
                })
              });
      print('messages ${messages.length} first ${messages[0].text}');
    }

    return messages;
  }

  @override
  void sendMessage(String userId, String text) async {
    var currentUserId = await userRepository.getCurrentUserId();
    var newMessage = MessageModel();
    newMessage.text = text;
    newMessage.isMine = true;
    newMessage.createdAt = DateTime.now();

    var newClientMessage = MessageModel();
    newClientMessage.text = text;
    newClientMessage.isMine = false;
    newClientMessage.createdAt = DateTime.now();

    var chat = await db
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .get();

    if (chat.docs.isNotEmpty) {
      newMessage.chatId = ChatModel.fromJson(chat.docs[0].data()).chatId;

      print('chat ${ChatModel.fromJson(chat.docs[0].data()).chatWith}');
      await chat.docs[0].reference
          .collection('messages')
          .add(newMessage.toJson())
          .then((value) => {
                newMessage.messageId = value.id,
                value.update(newMessage.toJson())
              });

      var chatClient = await db
          .collection('users')
          .doc(userId)
          .collection('chats')
          .where('chatWith', isEqualTo: currentUserId);

      await chatClient.get().then((value) => {
            newClientMessage.chatId =
                ChatModel.fromJson(value.docs[0].data()).chatId,
            value.docs[0].reference
                .collection('messages')
                .add(newClientMessage.toJson())
                .then((value) => {
                      newClientMessage.messageId = value.id,
                      value.update(newClientMessage.toJson())
                    })
          });
    } else {
      startNewChat(userId, text);
    }
  }
}
