// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../domain/interactors/chat_interactor.dart';
import '../domain/repository/chat_repository.dart';
import '../data/repository/chat_repository_impl.dart';
import '../ui/bloc/chat_bloc.dart';
import '../domain/interactors/event_interactor.dart';
import '../domain/repository/event_repository.dart';
import '../data/repository/event_repository_impl.dart';
import '../ui/bloc/event_bloc.dart';
import '../ui/bloc/notification_bloc.dart';
import '../domain/interactors/notification_interactor.dart';
import '../domain/repository/notification_repository.dart';
import '../data/repository/notification_repository_impl.dart';
import '../domain/interactors/story_interactor.dart';
import '../domain/repository/story_repository.dart';
import '../data/repository/story_repository_impl.dart';
import '../domain/interactors/user_interactor.dart';
import '../domain/repository/user_repository.dart';
import '../data/repository/user_repository_impl.dart';
import '../ui/bloc/user_bloc.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);

  gh.singleton<UserRepositoryImpl>(UserRepositoryImpl());
  gh.singleton<StoryRepositoryImpl>(StoryRepositoryImpl());

  gh.factory<ChatRepositoryImpl>(() => ChatRepositoryImpl());
  gh.factory<ChatInteractor>(() => ChatInteractor(get<ChatRepositoryImpl>()));
  gh.factory<ChatsBloc>(() => ChatsBloc());
  gh.factory<EventRepositoryImpl>(() => EventRepositoryImpl());
  gh.factory<EventInteractor>(() => EventInteractor(get<EventRepositoryImpl>()));
  gh.factory<EventsBloc>(() => EventsBloc());
  gh.factory<NotificationInteractor>(
      () => NotificationInteractor(get<NotificationRepositoryImpl>()));
  gh.factory<StoryInteractor>(() => StoryInteractor(get<StoryRepositoryImpl>()));
  gh.factory<UserInteractor>(() => UserInteractor(get<UserRepositoryImpl>()));
  gh.factory<UsersBloc>(() => UsersBloc());
  gh.factory<NotificationRepositoryImpl>(
      () => NotificationRepositoryImpl(get<UserRepositoryImpl>()));

  // Eager singletons must be registered in the right order
  gh.singleton<NotificationBloc>(NotificationBloc());
  return get;
}
