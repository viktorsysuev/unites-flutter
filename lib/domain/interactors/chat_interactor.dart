

import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/models/message_model.dart';
import 'package:unites_flutter/domain/repository/chat_repository.dart';


@injectable
class ChatInteractor {

  ChatInteractor(this.chatRepository);

  ChatRepository chatRepository;

  void startNewChat(String userId, String text){
    chatRepository.startNewChat(userId, text);
  }

  Future<List<MessageModel>> getChatMessages(String userId){
    return chatRepository.getChatMessages(userId);
  }

  void sendMessage(String userId, String text){
    chatRepository.sendMessage(userId, text);
  }
}