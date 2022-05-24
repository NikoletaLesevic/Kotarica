import 'package:flutter/material.dart';
import 'package:kotarica/chat/chat.dart';
import 'package:kotarica/model/MessageModel.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:provider/provider.dart';
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatUsers extends StatelessWidget {
  List<ChatMessageModel> users = [];
  String rememberedUser;

  ChatUsers(var items, String user) {
    this.users = items;
    rememberedUser = user;
  }

  @override
  Widget build(BuildContext context) {
    var signalR = Provider.of<SignalHelper>(context);
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        var lastMessage = users[index];
        // print('PORUKA MESSAGE IS ${lastMessage.date.hour}:${lastMessage.date.minute}');
        var chatUser = lastMessage.sender == rememberedUser ? lastMessage.receiver : lastMessage.sender;
        if(signalR.hubConnection.state != HubConnectionState.disconnected) {
          if (!signalR.requestedUsers.contains(chatUser) &&
              !signalR.onlineUsers.contains(chatUser)) {
            signalR.checkUserStatus(chatUser);
          }
          if (signalR.requestedUsers.contains(rememberedUser)) {
            signalR.goOnline(rememberedUser);
          }
        }

        bool isOnline = false;

        if(signalR.onlineUsers.contains(chatUser)) {
          isOnline = true;
        }
        print(lastMessage);
        // print(lastMessage["sender"]);
        final Message chat = chats[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Chat(
                  chatUser: chatUser,
                  loginUser: rememberedUser,
                // user: chat.sender,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: chat.unread
                      ? BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  )
                      : BoxDecoration(
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
                    radius: 35,
                    backgroundImage: ExactAssetImage('images/avatar.png'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                chatUser,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isOnline
                                  ? Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                                  : Container(
                                child: null,
                              ),
                            ],
                          ),
                          Text(
                            '${lastMessage.date.hour}:${lastMessage.date.minute}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          lastMessage.message,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
