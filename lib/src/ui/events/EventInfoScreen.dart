import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/CommentModel.dart';
import 'package:unites_flutter/src/models/CommentWithUser.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/ui/events/ParticipantsListScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';
import 'package:unites_flutter/src/ui/profile/UserInfoScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class EventInfoScreen extends StatefulWidget {
  String eventId;

  EventInfoScreen({@required this.eventId});

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  final eventBloc = EventsBloc();
  final formatter = DateFormat('yyyy-MM-dd hh:mm');
  var buttonText = '';
  var textEditingController = TextEditingController();

  @override
  void initState() {
    eventBloc.getEventCommetns(widget.eventId);
    eventBloc.addParticipantsListener();
    eventBloc.isMember(widget.eventId).then((isParticipant) => {
          if (isParticipant)
            {buttonText = 'Покинуть мероприятие'}
          else
            {buttonText = 'Присоединиться'}
        });
    eventBloc.getEventWithParticipants(widget.eventId);
    super.initState();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
  }

  Widget _buildParticipantsScroller(List<ParticipantsModel> participants) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: SizedBox.fromSize(
        size: Size.fromHeight(75.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: participants.length,
          itemBuilder: (BuildContext context, int index) {
            var user = participants[index];
            return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserInfoScreen(userId: user.userId)));
                    },
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: EditProfileScreen.colorById(user.userId),
                      child: ClipOval(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: user.avatar != null
                              ? Image.network(
                                  user.avatar,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                      '${user.firstName[0]}${user.lastName[0]}',
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                      textAlign: TextAlign.center)),
                        ),
                      ),
                    )));
          },
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<List<CommentWithUser>>(
        stream: eventBloc.comments,
        builder: (BuildContext context,
            AsyncSnapshot<List<CommentWithUser>> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Container(
              padding: EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: EditProfileScreen.colorById(
                              snapshot.data[index].authorId),
                          child: ClipOval(
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: snapshot.data[index].avatar != null
                                  ? Image.network(
                                      snapshot.data[index].avatar,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text(
                                          '${snapshot.data[index].firstName[0]}${snapshot.data[index].firstName[0]}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                          textAlign: TextAlign.center)),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text(
                                      '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}',
                                      style: TextStyle(fontSize: 16.0),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                        child: Text(
                                            '${getCommentTime(snapshot.data[index].createdAt)}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.white54)))),
                              ],
                            ))
                      ]),
                      Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapshot.data[index].text}',
                                style: TextStyle(color: Colors.white70),
                                textAlign: TextAlign.left,
                              )))
                    ]);
                  }),
            );
          } else {
            eventBloc.getEventCommetns(widget.eventId);
            child = Container();
          }

          return child;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Мероприятие'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<EventWithParticipants>(
            stream: eventBloc.eventWithParticipants,
            builder: (BuildContext context,
                AsyncSnapshot<EventWithParticipants> snapshot) {
              Widget child;

              if (snapshot.hasData) {
                child = SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.eventModel.name}',
                          style: TextStyle(fontSize: 22.0)),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('${snapshot.data.eventModel.description}',
                              style: TextStyle(fontSize: 16.0)),
                        )),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.eventModel.company}',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Адрес:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('${snapshot.data.eventModel.address}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            Text('Начало:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data.eventModel.start)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Завершение:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data.eventModel.end)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                  text:
                                      'Участники (${snapshot.data.participants.length}):',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipantsListScreen(
                                                      eventId: snapshot.data
                                                          .eventModel.id)));
                                    }),
                            ),
                          ]),
                    ),
                    _buildParticipantsScroller(snapshot.data.participants),
                    Container(margin: EdgeInsets.only(top: 12.0, bottom: 12.0)),
                    Container(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      width: double.infinity,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        child: Text(
                          '$buttonText',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          eventBloc
                              .isMember(widget.eventId)
                              .then((isParticipant) => {
                                    if (isParticipant)
                                      {
                                        print("left"),
                                        eventBloc.leftEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(
                                            widget.eventId),
                                      }
                                    else
                                      {
                                        eventBloc.joinEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(
                                            widget.eventId),
                                      }
                                  });
                          setState(() {
                            if (buttonText == 'Присоединиться') {
                              buttonText = 'Покинуть мероприятие';
                            } else {
                              buttonText = 'Присоединиться';
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 12.0, top: 24.0, bottom: 16.0),
                      alignment: Alignment.centerLeft,
                      child:
                          Text('Комментарии', style: TextStyle(fontSize: 20.0)),
                    ),
                    // Edit text
                    Container(
                      margin: EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          // Button send image
                          // Edit text
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 18.0),
                              child: TextField(
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                                controller: textEditingController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Оставьте комментарий',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),

                          // Button send message
                          Material(
                            child: Container(
                              padding: EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => {
                                  eventBloc.sendComment(
                                      textEditingController.text,
                                      widget.eventId),
                                  textEditingController.clear()
                                },
                                color: Colors.blueAccent,
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.black12),
                    ),

                    _buildCommentsList()
                  ]),
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

  String getCommentTime(DateTime date) {
    var res = '';
    var formatter = DateFormat('hh:mm');
    var formatterForRest = DateFormat('dd MMMM hh:mm');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (DateTime(date.year, date.month, date.day) == today) {
      res = 'Сегодня в ${formatter.format(date)}';
    } else if (DateTime(date.year, date.month, date.day) == yesterday) {
      res = 'Вчера в ${formatter.format(date)}';
    } else {
      res = '${formatterForRest.format(date)}';
    }
    return res;
  }
}
