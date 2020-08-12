



class ChatModel {
  String chatId;
  String chatWith;

  ChatModel({this.chatId, this.chatWith});

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) =>
      _ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _ChatModelToJson(this);
}

ChatModel _ChatModelFromJson(Map<dynamic, dynamic> json) {
  return ChatModel(
      chatId: json['chatId'] as String, chatWith: json['chatWith'] as String);
}

Map<String, dynamic> _ChatModelToJson(ChatModel instance) =>
    <String, dynamic>{'chatId': instance.chatId, 'chatWith': instance.chatWith};
