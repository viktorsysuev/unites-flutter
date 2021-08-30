import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unites_flutter/domain/models/message_model.dart';
import 'package:unites_flutter/ui/bloc/chat_bloc_new.dart';

class PrivateChatScreen extends StatelessWidget {
  PrivateChatScreen({required this.userId});

  String userId;

  var textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatBlocNew>().add(FetchAllMessagesEvent(userId: userId));
    return Scaffold(
      appBar: AppBar(
        title: Text('Приватный чат'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Flexible(
                  child: _buildList(),
                ),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5)),
                      color: Colors.white),
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
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => {
                              context.read<ChatBlocNew>().add(SendMessageEvent(
                                  userId: userId,
                                  text: textEditingController.text)),
                              textEditingController.clear()
                            },
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: 10.0, left: 50.0),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ])
        : Wrap(children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: Text(
                message.text,
                style: TextStyle(color: Colors.white),
              ),
            )
          ]);
  }

  Widget _buildList() {
    return BlocBuilder<ChatBlocNew, ChatBlocState>(
      builder: (_, state) {
        if (state.messages.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildItem(index, state.messages[index]),
            itemCount: state.messages.length,
            reverse: true,
            controller: listScrollController,
          );
        }
      },
    );
  }
}
