// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/chat_repository_impl.dart';
import '../ui/bloc/chat_bloc.dart';
import '../data/repository/event_repository_impl.dart';
import '../ui/bloc/event_bloc.dart';
import '../ui/bloc/notification_bloc.dart';
import '../data/repository/notification_repository_impl.dart';
import '../data/repository/story_repository_impl.dart';
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

  gh.factory<ChatRepositoryImpl>(() => ChatRepositoryImpl());
  gh.factory<ChatsBloc>(() => ChatsBloc());
  gh.factory<EventRepositoryImpl>(() => EventRepositoryImpl());
  gh.factory<EventsBloc>(() => EventsBloc());
  gh.factory<NotificationRepositoryImpl>(() => NotificationRepositoryImpl());
  gh.factory<UsersBloc>(() => UsersBloc());

  // Eager singletons must be registered in the right order
  gh.singleton<NotificationBloc>(NotificationBloc());
  gh.singleton<StoryRepositoryImpl>(StoryRepositoryImpl());
  return get;
}
