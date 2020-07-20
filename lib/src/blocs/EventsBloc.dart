import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';

class EventsBloc {
  final _eventRepository = EventRepository();
  final _eventFetcher = PublishSubject<EventModel>();

  Stream<EventModel> get getAllEvents => _eventFetcher.stream;

  fetchAllEvent() async {}

  createEvent(EventModel eventModel) {
    _eventRepository.addNewEvent(eventModel);
  }

  dispose() {
    _eventFetcher.close();
  }
}
