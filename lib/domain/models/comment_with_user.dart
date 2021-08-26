import 'package:cloud_firestore/cloud_firestore.dart';

class CommentWithUser {
  String commentId;
  String authorId;
  DateTime? createdAt;
  String eventId;
  String text;
  String firstName;
  String lastName;
  String? avatar;

  CommentWithUser(
      {required this.commentId,
      required this.authorId,
      this.createdAt,
      this.eventId = '',
      this.text = '',
      this.firstName = '',
      this.lastName = '',
      this.avatar});

  factory CommentWithUser.fromJson(Map<dynamic, dynamic> json) =>
      _CommentWithUserFromJson(json);

  factory CommentWithUser.fromDB(Map<String, dynamic> table) {
    return CommentWithUser(
        commentId: table['commentId'],
        authorId: table['authorId'],
        createdAt: DateTime.parse(table['createdAt']),
        eventId: table['eventId'],
        text: table['text'],
        firstName: table['firstName'],
        lastName: table['lastName'],
        avatar: table['avatar']);
  }

  Map<String, dynamic> toJson() => _CommentWithUserToJson(this);

  Map<String, dynamic> toMap() => _CommentWithUserToMap(this);

  @override
  String toString() => 'Event <$commentId>';
}

CommentWithUser _CommentWithUserFromJson(Map<dynamic, dynamic> json) {
  return CommentWithUser(
      commentId: json['commentId'] as String,
      authorId: json['description'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] as Timestamp).toDate(),
      eventId: json['eventId'] as String,
      text: json['text'] as String);
}

Map<String, dynamic> _CommentWithUserToJson(CommentWithUser instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt,
      'eventId': instance.eventId,
      'text': instance.text,
    };

Map<String, dynamic> _CommentWithUserToMap(CommentWithUser instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'eventId': instance.eventId,
      'text': instance.text,
    };
