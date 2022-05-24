import 'package:flutter/material.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:provider/provider.dart';

class SendMessageArea extends StatelessWidget {
  final messageController = TextEditingController();
  final String sender;
  final String receiver;

  SendMessageArea({
    this.sender,
    this.receiver
  });

  @override
  Widget build(BuildContext context) {
    var signalR = Provider.of<SignalHelper>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await signalR.startConnection();
              signalR.sendMessage(sender, receiver, messageController.text);
            },
          ),
        ],
      ),
    );
  }
}
