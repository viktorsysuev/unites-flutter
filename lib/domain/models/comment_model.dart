

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/domain/models/participants_model.dart';

class CommentModel {
  String commentId;
  String authorId;
  DateTime createdAt;
  String eventId;
  String text;

  CommentModel(
      {this.commentId,
        this.authorId,
        this.createdAt,
        this.eventId,
        this.text});

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) =>
      _CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _CommentModelToJson(this);

  Map<String, dynamic> toMap() => _CommentModelToMap(this);

  factory CommentModel.fromDB(Map<String, dynamic> table) {
    return CommentModel(
        commentId: table['commentId'],
        authorId: table['authorId'],
        createdAt: DateTime.parse(table['createdAt']),
        eventId: table['eventId'],
        text: table['text']);
  }

  @override
  String toString() => "Event <$commentId>";
}

CommentModel _CommentModelFromJson(Map<dynamic, dynamic> json) {
  return CommentModel(
    commentId: json['commentId'] as String,
    authorId: json['authorId'] as String,
    createdAt: json['createdAt'] == null ? null : (json['createdAt'] as Timestamp).toDate(),
    eventId: json['eventId'] as String,
    text: json['text'] as String
  );
}

Map<String, dynamic> _CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt,
      'eventId': instance.eventId,
      'text': instance.text,
    };

Map<String, dynamic> _CommentModelToMap(CommentModel instance) => <String, dynamic>{
  'commentId': instance.commentId,
  'authorId': instance.authorId,
  'createdAt': instance.createdAt.toIso8601String(),
  'eventId': instance.eventId,
  'text': instance.text,
};

