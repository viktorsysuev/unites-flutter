import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/story_model.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';

@singleton
@injectable
class StoryRepository {
  var userRepository = getIt<UserRepository>();
  final db = Firestore.instance;

  void initStories() {
    db.collectionGroup('stories').getDocuments().then((value) => {
          value.documents.forEach((element) {
            DatabaseProvider.db.insertData(
                'stories', StoryModel.fromJson(element.data).toMap());
          })
        });
  }

  Future<List<StoryModel>> getStories(String userId) async {
    return DatabaseProvider.db.getStories(userId);
  }

  void createStory(StoryModel story) async {
    var userId = userRepository.currentUser.userId;
    await db
        .collection('users')
        .document(userId)
        .collection('stories')
        .add(story.toJson())
        .then((value) => {
              story.storyId = value.documentID,
              value.updateData(story.toJson()),
              print('story insert in db ${story.storyId}'),
              DatabaseProvider.db.insertData('stories', story.toMap())
            });
  }
}
