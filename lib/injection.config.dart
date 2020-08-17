// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'src/resources/chat_repository.dart';
import 'src/blocs/chat_bloc.dart';
import 'src/resources/event_repository.dart';
import 'src/blocs/event_bloc.dart';
import 'src/blocs/notification_bloc.dart';
import 'src/resources/notification_repository.dart';
import 'src/resources/user_repository.dart';
import 'src/blocs/user_bloc.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.factory<ChatRepository>(() => ChatRepository());
  gh.factory<ChatsBloc>(() => ChatsBloc());
  gh.factory<EventRepository>(() => EventRepository());
  gh.factory<EventsBloc>(() => EventsBloc());
  gh.factory<NotificationRepository>(() => NotificationRepository());
  gh.factory<UserRepository>(() => UserRepository());
  gh.factory<UsersBloc>(() => UsersBloc());

  // Eager singletons must be registered in the right order
  gh.singleton<NotificationBloc>(NotificationBloc());
  return get;
}
