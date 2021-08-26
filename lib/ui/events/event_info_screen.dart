import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/event_bloc.dart';
import 'package:unites_flutter/domain/models/comment_with_user.dart';
import 'package:unites_flutter/domain/models/event_with_participants.dart';
import 'package:unites_flutter/domain/models/participants_model.dart';
import 'package:unites_flutter/ui/events/participants/participants_list_screen.dart';
import 'package:unites_flutter/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/ui/profile/userInfo_screen.dart';
import 'package:unites_flutter/ui/widgets/little_widgets_collection.dart';

class EventInfoScreen extends StatefulWidget {
  EventInfoScreen({required this.eventId});

  final String eventId;

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  final eventBloc = getIt<EventsBloc>();
  final formatter = DateFormat('yyyy-MM-dd hh:mm');
  var buttonText = '';
  var textEditingController = TextEditingController();
  static const LatLng _center = LatLng(45.521563, -122.677433);

  @override
  void didChangeDependencies() {
    eventBloc.getEventCommetns(widget.eventId);
    eventBloc.addParticipantsListener();
    eventBloc.isMember(widget.eventId).then((isParticipant) => {
          if (isParticipant)
            {buttonText = 'Покинуть мероприятие'}
          else
            {buttonText = 'Присоединиться'}
        });
    eventBloc.getEventWithParticipants(widget.eventId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
//    eventBloc.dispose();
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
                                  user.avatar!,
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
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      Row(children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserInfoScreen(
                                          userId:
                                              snapshot.data![index].authorId)));
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: EditProfileScreen.colorById(
                                  snapshot.data![index].authorId),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: snapshot.data![index].avatar != null
                                      ? Image.network(
                                          snapshot.data![index].avatar!,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                              '${snapshot.data![index].firstName[0]}${snapshot.data![index].firstName[0]}',
                                              style: TextStyle(fontSize: 24),
                                              textAlign: TextAlign.center)),
                                ),
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserInfoScreen(
                                                          userId: snapshot
                                                              .data![index]
                                                              .authorId)));
                                        },
                                        child: Text(
                                          '${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',
                                          style: TextStyle(fontSize: 16.0),
                                        ))),
                                Container(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            '${getCommentTime(snapshot.data![index].createdAt!)}',
                                            textAlign: TextAlign.left))),
                              ],
                            ))
                      ]),
                      Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapshot.data![index].text}',
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
                    Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Center(
                          child: Text('${snapshot.data?.eventModel?.name}',
                              style: TextStyle(fontSize: 22.0)),
                        )),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Center(
                          child: Text(
                              '${snapshot.data?.eventModel?.description}',
                              style: TextStyle(fontSize: 16.0)),
                        )),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data?.eventModel?.company}',
                          textAlign: TextAlign.center,
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
                            Text('${snapshot.data?.eventModel?.address}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            Text('Начало:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data!.eventModel!.start!)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Завершение:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data!.eventModel!.end!)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                  text: 'Участники:',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipantsListScreen(
                                                      eventId: snapshot.data!
                                                          .eventModel!.id)));
                                    }),
                            ),
                          ]),
                    ),
                    _buildParticipantsScroller(snapshot.data!.participants!),
                    Container(margin: EdgeInsets.only(top: 12.0, bottom: 12.0)),
                    Container(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      width: double.infinity,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        onPressed: () {
                          eventBloc
                              .isMember(widget.eventId)
                              .then((isParticipant) => {
                                    if (isParticipant)
                                      {
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
                        child: Text(
                          '$buttonText',
                          style: TextStyle(color: Colors.blue),
                        ),
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
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.black12),
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
                            color: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => {
                                  if (textEditingController.text.isNotEmpty)
                                    {
                                      eventBloc.sendComment(
                                          textEditingController.text,
                                          widget.eventId)
                                    },
                                  textEditingController.clear()
                                },
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
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
