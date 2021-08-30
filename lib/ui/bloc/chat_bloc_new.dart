import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unites_flutter/domain/interactors/chat_interactor.dart';
import 'package:unites_flutter/domain/interactors/user_interactor.dart';
import 'package:unites_flutter/domain/models/message_model.dart';

import '../main.dart';

class ChatBlocNew extends Bloc<NewChatEvent, ChatBlocState> {
  ChatBlocNew() : super(ChatBlocState());

  var chatInteractor = getIt<ChatInteractor>();
  var userInteractor = getIt<UserInteractor>();

  @override
  Stream<ChatBlocState> mapEventToState(NewChatEvent event) async* {
    switch (event.runtimeType) {
      case SendMessageEvent:
        print('sendMessage');
        final ev = event as SendMessageEvent;
        chatInteractor.sendMessage(ev.userId, ev.text);
        break;

      case FetchAllMessagesEvent:
        var messages = await chatInteractor.getChatMessages((event as FetchAllMessagesEvent).userId);
        print('fetchAllMessages, size=${messages.length}');
        state.messages = messages;
        break;
    }
    print('yield state');
    yield state;
  }
}

abstract class NewChatEvent {}

class SendMessageEvent extends NewChatEvent {
  SendMessageEvent({required this.userId, required this.text});

  String userId;
  String text;
}

class FetchAllMessagesEvent extends NewChatEvent {
  FetchAllMessagesEvent({required this.userId});

  String userId;
}

class ChatBlocState {
  List<MessageModel> messages = [];
}
