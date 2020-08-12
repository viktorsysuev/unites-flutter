import 'package:unites_flutter/src/models/event_model.dart';
import 'package:unites_flutter/src/models/participants_model.dart';

class EventWithParticipants {
  EventModel eventModel;
  List<ParticipantsModel> participants;

  EventWithParticipants({this.eventModel, this.participants});

}
