import 'dart:async';

import 'package:unites_flutter/domain/interactors/story_interactor.dart';
import 'package:unites_flutter/domain/interactors/user_interactor.dart';
import 'package:unites_flutter/ui/bloc/user_bloc.dart';
import 'package:unites_flutter/domain/models/story_model.dart';
import 'package:unites_flutter/data/repository/story_repository_impl.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

import '../main.dart';


class StoryBloc {
  var storyInteractor = getIt<StoryInteractor>();
  var userBloc = getIt<UsersBloc>();

  final storiesFetcher = StreamController<List<StoryModel>>.broadcast();

  Stream<List<StoryModel>> get getStories => storiesFetcher.stream;


  void fetchStories(String userId) async {
    var stories = await storyInteractor.getStories(userId);
    storiesFetcher.sink.add(stories);
  }


  void createStory(StoryModel story) async {
    await storyInteractor.createStory(story);
  }
}