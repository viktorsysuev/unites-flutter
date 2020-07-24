import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';

class EventWithParticipants {
  EventModel eventModel;
  List<ParticipantsModel> participants;

  EventWithParticipants({this.eventModel, this.participants});

}
