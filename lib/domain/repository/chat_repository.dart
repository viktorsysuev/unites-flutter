
import 'package:unites_flutter/domain/models/message_model.dart';



abstract class ChatRepository {


  void startNewChat(String userId, String text);

  Future<List<MessageModel>> getChatMessages(String userId);

  void sendMessage(String userId, String text);


}