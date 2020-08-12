import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/src/models/chat_model.dart';
import 'package:unites_flutter/src/models/message_model.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';

class ChatRepository {
  final db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var userRepository = UserRepository();

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
        .document(currentUserId)
        .collection('chats')
        .add(newChat.toJson())
        .then((value) => {
              newChat.chatId = value.documentID,
              db
                  .collection('users')
                  .document(currentUserId)
                  .collection('chats')
                  .document(value.documentID)
                  .updateData(newChat.toJson())
                  .whenComplete(() => {
                        newMessage.chatId = value.documentID,
                        value
                            .collection('messages')
                            .add(newMessage.toJson())
                            .then((value) => {
                                  newMessage.messageId = value.documentID,
                                  value.updateData(newMessage.toJson())
                                })
                      })
            });

    await db
        .collection('users')
        .document(userId)
        .collection('chats')
        .add(newClientChat.toJson())
        .then((value) => {
              newClientChat.chatId = value.documentID,
              db
                  .collection('users')
                  .document(userId)
                  .collection('chats')
                  .document(value.documentID)
                  .updateData(newClientChat.toJson())
                  .whenComplete(() => {
                        newClientMessage.chatId = value.documentID,
                        value
                            .collection('messages')
                            .add(newClientMessage.toJson())
                            .then((value) => {
                                  newClientMessage.messageId = value.documentID,
                                  value.updateData(newClientMessage.toJson())
                                })
                      })
            });
  }

  Future<List<MessageModel>> getChatMessages(String userId) async {
    var messages = List<MessageModel>();
    var currentUserId = await userRepository.getCurrentUserId();
    var chat = await db
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .getDocuments();

    if (chat.documents.isNotEmpty) {
      await chat.documents[0].reference
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  messages.add(MessageModel.fromJson(element.data));
                })
              });
      print('messages ${messages.length} first ${messages[0].text}');
    }

    return messages;
  }

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
        .document(currentUserId)
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .getDocuments();

    if (chat.documents.isNotEmpty) {
      newMessage.chatId = ChatModel.fromJson(chat.documents[0].data).chatId;

      print('chat ${ChatModel.fromJson(chat.documents[0].data).chatWith}');
      await chat.documents[0].reference
          .collection('messages')
          .add(newMessage.toJson())
          .then((value) => {
                newMessage.messageId = value.documentID,
                value.updateData(newMessage.toJson())
              });

      var chatClient = await db
          .collection('users')
          .document(userId)
          .collection('chats')
          .where('chatWith', isEqualTo: currentUserId);

      await chatClient.getDocuments().then((value) => {
            newClientMessage.chatId =
                ChatModel.fromJson(value.documents[0].data).chatId,
            value.documents[0].reference
                .collection('messages')
                .add(newClientMessage.toJson())
                .then((value) => {
                      newClientMessage.messageId = value.documentID,
                      value.updateData(newClientMessage.toJson())
                    })
          });
    } else {
      startNewChat(userId, text);
    }
  }
}
