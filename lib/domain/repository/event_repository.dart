import 'package:unites_flutter/domain/models/comment_with_user.dart';
import 'package:unites_flutter/domain/models/event_model.dart';
import 'package:unites_flutter/domain/models/event_with_participants.dart';
import 'package:unites_flutter/domain/models/participants_model.dart';
import 'package:unites_flutter/domain/models/user_model.dart';

abstract class EventRepository {
  Future<List<EventModel>> initEvents();

  void addNewEvent(EventModel event);

  void addNewComment(String text, String eventId);

  void joinEvent(String eventId);

  void leftEvent(String eventId);

  void updateEvent(EventModel event);

  Future<List<EventModel>> getAllEvents();

  Future<List<UserModel>> getEventParticipantsFromDB(String eventId);

  Future<List<CommentWithUser>> getEventComments(String eventId);

  Future<List<EventWithParticipants>> getMyEvents();

  Future<List<EventModel>> getAllEventsFromDB();

  void deleteEvent(String eventId);

  Future<EventModel> getEvent(String eventId);

  Future<List<ParticipantsModel>> getEventParticipants(String eventId);

  Future<bool> isParticipant(String eventId);
}
