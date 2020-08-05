import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unites_flutter/src/App.dart';
import 'package:unites_flutter/src/blocs/ChatsBloc.dart';
import 'package:unites_flutter/src/models/MessageModel.dart';

class PrivateChatScreen extends StatefulWidget {
  String userId;

  PrivateChatScreen({@required this.userId});

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  var textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  var listMessage = <MessageModel>[];

  var chatsBloc = ChatsBloc();

  @override
  void initState() {
    chatsBloc.addMessagesListener(widget.userId);
    chatsBloc.fetchAllMessages(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Приватный чат'),
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Flexible(
                  child: StreamBuilder<List<MessageModel>>(
                    stream: chatsBloc.getMessages,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black)));
                      } else {
                        listMessage = snapshot.data;
//                        listMessage.sort((MessageModel a, MessageModel b) => b.createdAt.compareTo(a.createdAt));
                        return ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) =>
                              buildItem(index, listMessage[index]),
                          itemCount: listMessage.length,
                          reverse: true,
                          controller: listScrollController,
                        );
                      }
                    },
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      // Button send image
                      // Edit text
                      Flexible(
                        child: Container(
                          child: TextField(
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                            controller: textEditingController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Введите сообщение...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      // Button send message
                      Material(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => {
                              chatsBloc.sendNewMessage(
                                  widget.userId, textEditingController.text),
                              textEditingController.clear()
                            },
                            color: Colors.blueAccent,
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5)),
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onSendMessage(String text, int i) {}

  Widget buildItem(int index, MessageModel message) {
    return message.isMine
        ? Wrap(children: [
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: 10.0, left: 50.0),
                ))
          ])
        : Wrap(children: [
            Container(
              child: Text(
                message.text,
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
            )
          ]);
  }
}
