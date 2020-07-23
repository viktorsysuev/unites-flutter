import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';

class EventsBloc {
  final _eventRepository = EventRepository();
  final _allEventsFetcher = PublishSubject<List<EventModel>>();
  final _eventFetcher = PublishSubject<EventModel>();

  Stream<List<EventModel>> get getAllEvents => _allEventsFetcher.stream;

  Stream<EventModel> get getEvent => _eventFetcher.stream;

  createEvent(EventModel eventModel) {
    _eventRepository.addNewEvent(eventModel);
  }

  fetchAllEvents() {
    _eventRepository
        .getAllEvents()
        .then((value) => _allEventsFetcher.sink.add(value));
  }

  fetchEvent(String eventId) {
    _eventRepository
        .getEvent(eventId)
        .then((value) => _eventFetcher.sink.add(value));
  }

  dispose() {
    _allEventsFetcher.close();
  }
}
