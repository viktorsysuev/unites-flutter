import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/models/comment_with_user.dart';
import 'package:unites_flutter/domain/models/event_model.dart';
import 'package:unites_flutter/domain/models/event_with_participants.dart';
import 'package:unites_flutter/domain/models/participants_model.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/domain/repository/event_repository.dart';

@injectable
class EventInteractor {
  EventInteractor(this.eventRepository);

  EventRepository eventRepository;

  Future<List<EventModel>> initEvents() async {
    return await eventRepository.initEvents();
  }

  void addNewEvent(EventModel event) {
    eventRepository.addNewEvent(event);
  }

  void addNewComment(String text, String eventId) {
    eventRepository.addNewComment(text, eventId);
  }

  void joinEvent(String eventId) {
    eventRepository.joinEvent(eventId);
  }

  void leftEvent(String eventId) {
    eventRepository.leftEvent(eventId);
  }

  void updateEvent(EventModel event) {
    eventRepository.updateEvent(event);
  }

  Future<List<EventModel>> getAllEvents() {
    return eventRepository.getAllEvents();
  }

  Future<List<UserModel>> getEventParticipantsFromDB(String eventId) {
    return eventRepository.getEventParticipantsFromDB(eventId);
  }

  Future<List<CommentWithUser>> getEventComments(String eventId) {
    return eventRepository.getEventComments(eventId);
  }

  Future<List<EventWithParticipants>> getMyEvents() {
    return eventRepository.getMyEvents();
  }

  Future<List<EventModel>> getAllEventsFromDB() {
    return eventRepository.getAllEventsFromDB();
  }

  void deleteEvent(String eventId) {
    eventRepository.deleteEvent(eventId);
  }

  Future<EventModel> getEvent(String eventId) {
    return eventRepository.getEvent(eventId);
  }

  Future<List<ParticipantsModel>> getEventParticipants(String eventId) {
    return eventRepository.getEventParticipants(eventId);
  }

  Future<bool> isParticipant(String eventId) {
    return eventRepository.isParticipant(eventId);
  }
}
