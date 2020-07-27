import 'package:flutter/material.dart';
import 'package:unites_flutter/src/App.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/ui/profile/UserInfoScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class ParticipantsListScreen extends StatefulWidget {
  String eventId;

  ParticipantsListScreen({@required this.eventId});


  @override
  _ParticipantsListScreenState createState() => _ParticipantsListScreenState();
}


class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  final eventBloc = EventsBloc();

  @override
  void initState() {
    super.initState();
    eventBloc.getEventParticipants(widget.eventId);
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Участники'),
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<UserModel>>(
            stream: eventBloc.participants,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData) {
                snapshot.data.forEach((element) {
                  bufferWidgets.add(Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoScreen(userId: element.userId)));
                        },
                        title: Text('${element.firstName} ${element.lastName} '),
                        subtitle: Text('${element.company}'),
                      )));
                });
                child = Column(
                  children: bufferWidgets,
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              } else if (snapshot.hasError) {
                child = Center(child: WidgetErrorLoad());
              } else {
                child = Center(child: WidgetDataLoad());
              }
              return child;
            },
          ),
        ));
    ;
  }
}

