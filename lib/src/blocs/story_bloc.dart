import 'dart:async';

import 'package:unites_flutter/src/models/story_model.dart';
import 'package:unites_flutter/src/resources/story_repository.dart';

import '../../main.dart';

class StoryBloc {

  var storyRepository = getIt<StoryRepository>();

  final storiesFetcher = StreamController<List<StoryModel>>.broadcast();

  Stream<List<StoryModel>> get getStories => storiesFetcher.stream;




  void fetchStories(String userId) async {
    var stories = await storyRepository.getStories(userId);
    storiesFetcher.sink.add(stories);
  }
}