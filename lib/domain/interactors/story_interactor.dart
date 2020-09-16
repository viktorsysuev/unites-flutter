


import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/models/story_model.dart';
import 'package:unites_flutter/domain/repository/story_repository.dart';


@injectable
class StoryInteractor {
  StoryInteractor(this.storyRepository);

  StoryRepository storyRepository;


  void initStories(){
    storyRepository.initStories();
  }

  Future<List<StoryModel>> getStories(String userId){
    return storyRepository.getStories(userId);
  }

  void createStory(StoryModel story){
    storyRepository.createStory(story);
  }


}