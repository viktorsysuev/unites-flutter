

import 'package:unites_flutter/domain/models/story_model.dart';

abstract class StoryRepository {

  void initStories();

  Future<List<StoryModel>> getStories(String userId);

  void createStory(StoryModel story);
}