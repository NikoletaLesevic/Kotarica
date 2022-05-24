import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/auth/LoginPage.dart';
import 'package:kotarica/chat/ChatTextArea.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/MessageModel.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';


class Chat extends StatefulWidget {
  String chatUser;
  String loginUser;

  Chat({
    this.chatUser,
    this.loginUser
});

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  // String rememberUser;
  // bool zapamti=false;
  List<ChatMessageModel> chat = [];
  Set set = new Set();
  bool isLoading = false;
  // List<ChatMessageModel> newMessages = [];

  @override
  void initState() {

    super.initState();
    this.fetchChat();
  }

  fetchChat() async {
    setState(() {
      isLoading = false;
    });

    // String url = "http://10.0.2.2:5000/api/messages/" + rememberUser + widget.user.userName;
    String url = "${Config.BACKEND_REST}/api/chat/" + widget.loginUser + "/" + widget.chatUser;
    print(url);

    var response = await http.get(url);
    if(response.statusCode == 200) {
      var items = json.decode(response.body);
      List<ChatMessageModel> pom = [];
      Set pomSet = new Set();
      for(int i=0; i<items.length; i++) {
        print("DATUM JE " + items[i]["date"]);
        pom.add(ChatMessageModel(items[i]["sender"], items[i]["receiver"], items[i]["message"], items[i]["date"]));
        pomSet.add(items[i]["message"]);
      }
      setState(() {
        chat = pom;
        set = pomSet;
        isLoading = false;
      });
    } else {
      chat = [];
      isLoading = false;
      print(chat);
    }
  }




  _chatBubble(var message, bool isMe, bool isSameUser) {
    if(isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${message.date.hour}:${message.date.minute}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: ExactAssetImage("images/avatar.png"),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: ExactAssetImage("images/avatar.png"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${message.date.hour}:${message.date.minute}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var signalR = Provider.of<SignalHelper>(context);
    if(signalR.hubConnection.state != HubConnectionState.disconnected) {
      if (signalR.requestedUsers.contains(widget.loginUser)) {
        signalR.goOnline(widget.loginUser);
      }
      else if (!signalR.onlineUsers.contains(widget.loginUser)) {
        print("USER NE POSTOJI");
        signalR.goOnline(widget.loginUser);
      }

      // if (signalR.requestedUsers.contains(widget.chatUser) &&
      //     !signalR.onlineUsers.contains(widget.chatUser)) {
      //   signalR.checkUserStatus(widget.chatUser);
      // }
    }

    bool isOnline = false;

    if(signalR.onlineUsers.contains(widget.chatUser)) {
      isOnline = true;
    }
    List<ChatMessageModel> pom = [];
    print(chat.length);
    for(var i=0; i<chat.length; i++) {
      pom.add(chat[i]);
    }
    for(var i = 0; i<signalR.listOfNewChatMessages.length; i++) {
      ChatMessageModel chatMessage = signalR.listOfNewChatMessages[i];
      if(!set.contains(chatMessage.message) && ((chatMessage.sender == widget.chatUser && chatMessage.receiver == widget.loginUser) ||
          (chatMessage.sender == widget.loginUser && chatMessage.receiver == widget.chatUser))) {
        pom.insert(0, chatMessage);
        set.add(chatMessage.message);
      }
    }



    setState(() {
      chat = pom;
    });
    print(chat);
    // print(widget.user.userName);
    // print("USER " + widget.user.toString());
    String previousUserName;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: widget.chatUser,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    )),
                TextSpan(text: '\n'),
                isOnline
                    ? TextSpan(
                        text: 'Online',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : TextSpan(
                        text: 'Offline',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(20),
                // itemCount: messages.length,
                itemCount: chat.length,
                itemBuilder: (BuildContext context, int index) {
                  var message = chat[index];
                  // final Message message = messages[index];
                  final bool isMe =
                      message.sender == widget.loginUser;
                  final bool isSameUser =
                      previousUserName == message.sender;
                  previousUserName = message.sender;
                  // previousUserName = message.sender.userName;
                  return _chatBubble(message, isMe, isSameUser);
                },
              ),
            ),
            SendMessageArea(sender: widget.loginUser, receiver: widget.chatUser),
            (widget.loginUser != null) ? Text(widget.loginUser) : Text("user"),
          ],
        ));
  }
}

