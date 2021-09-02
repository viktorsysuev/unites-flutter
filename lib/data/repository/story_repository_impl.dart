import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/repository/story_repository.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/story_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

@singleton
@injectable
class StoryRepositoryImpl implements StoryRepository {
  var userRepository = getIt<UserRepositoryImpl>();
  final db = FirebaseFirestore.instance;

  @override
  void initStories() {
    db.collectionGroup('stories').get().then((value) => {
          value.docs.forEach((element) {
            DatabaseProvider.db.insertData(
                'stories', StoryModel.fromJson(element.data()).toMap());
          })
        });
  }

  @override
  Future<List<StoryModel>> getStories(String userId) async {
    return DatabaseProvider.db.getStories(userId);
  }

  @override
  void createStory(StoryModel story) async {
    var userId = userRepository.currentUser?.userId;
    await db
        .collection('users')
        .doc(userId)
        .collection('stories')
        .add(story.toJson())
        .then((value) => {
              story.storyId = value.id,
              value.update(story.toJson()),
              print('story insert in db ${story.storyId}'),
              DatabaseProvider.db.insertData('stories', story.toMap())
            });
  }
}
