

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String messageId;
  String text;
  DateTime createdAt;
  String chatId;
  bool isMine;

  MessageModel(
      {this.messageId, this.text, this.createdAt, this.chatId, this.isMine});

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) =>
      _MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _MessageModelToJson(this);
}

MessageModel _MessageModelFromJson(Map<dynamic, dynamic> json) {
  return MessageModel(
    messageId: json['messageId'] as String,
    text: json['text'] as String,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    chatId: json['chatId'] as String,
    isMine: json['isMine'] as bool,
  );
}

Map<String, dynamic> _MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'text': instance.text,
      'createdAt': instance.createdAt,
      'chatId': instance.chatId,
      'isMine': instance.isMine,
    };
