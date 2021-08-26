enum MediaType { VIDEO, IMAGE }

class StoryModel {
  String url;
  String storyId;
  MediaType? mediaType;
  int duration;
  String userId;

  StoryModel(
      {this.storyId = '',
      this.mediaType,
      this.userId = '',
      this.duration = 0,
      this.url = ''});

  factory StoryModel.fromJson(Map<dynamic, dynamic> json) =>
      _StoryModelFromJson(json);

  Map<String, dynamic> toMap() => _StoryModelToMap(this);

  factory StoryModel.fromDB(Map<String, dynamic> table) {
    return StoryModel(
        url: table['url'],
        storyId: table['storyId'],
        mediaType: MediaType.values.firstWhere(
            (e) => e.toString() == 'MediaType.' + table['mediaType']),
        userId: table['userId'],
        duration: table['duration']);
  }

  Map<String, dynamic> toJson() => _StoryModelToJson(this);
}

StoryModel _StoryModelFromJson(Map<dynamic, dynamic> json) {
  return StoryModel(
    url: json['url'] as String,
    storyId: json['storyId'] as String,
    duration: json['duration'],
    mediaType: MediaType.values
        .firstWhere((e) => e.toString() == 'MediaType.' + json['mediaType']),
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'storyId': instance.storyId,
      'duration': instance.duration,
      'mediaType': instance.mediaType.toString().split('.').last,
      'userId': instance.userId
    };

Map<String, dynamic> _StoryModelToMap(StoryModel instance) => <String, dynamic>{
      'url': instance.url,
      'storyId': instance.storyId,
      'duration': instance.duration,
      'mediaType': instance.mediaType.toString().split('.').last,
      'userId': instance.userId
    };
