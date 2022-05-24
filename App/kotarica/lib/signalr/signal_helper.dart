import 'package:flutter/widgets.dart';
import 'package:kotarica/config/config.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class SignalHelper extends ChangeNotifier {
  //final serverUrl = "https://10.0.2.2:44355/chathub";
  List<ChatMessageModel> listOfNewChatMessages = [];
  Set<String> onlineUsers = new Set();
  Set<String> requestedUsers = new Set();
  final serverUrl = "${Config.BACKEND_REST}/chathub";
  HubConnection hubConnection;

  SignalHelper() {
    initSignalR();
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose((error) => print('Connection clos'));
    hubConnection.on("ReceiveNewMessage", handleNewMessage);
    hubConnection.on("BeVisible", handleBeVisible);
    hubConnection.on("IsUserOnline", handleIsUserOnline);
    hubConnection.on("UserOffline", handleUserOffline);
    // startConnection();
  }
  
  

  startConnection() async {
    if(hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
      // hubConnection.on("ReceiveNewMessage", handleNewMessage);
      print("START CONNECTION");
    }

  }

  closeConnection() async {
    if(hubConnection.state != HubConnectionState.Disconnected) await hubConnection.stop();
    print("STOP CONNECTION");
  }

  sendMessage(String firstUser, String secondUser, String message) async {
    await hubConnection.invoke("ChatFromServer", args:<Object>[
      firstUser,
      secondUser,
      message
    ]);
    // notifyListeners();
  }
  
  goOnline(String user) async {
    await hubConnection.invoke("GoOnline", args:<Object>[user]);
    // notifyListeners();
  }

  goOffline(String user) async {
    await hubConnection.invoke("GoOffline", args:<Object>[user]);
    // notifyListeners();
  }

  checkUserStatus(String user) async {
    await hubConnection.invoke("CheckUserStatus", args:<Object>[user]);
    // notifyListeners();
  }

  handleNewMessage(List<Object> args) {
    print("Message is " + args[2]);
    print("DATUM JE " + args[3]);
    // listOfNewChatMessages.add(ChatMessageModel(args[0], args[1], args[2], args[3]));
    listOfNewChatMessages.insert(0, ChatMessageModel(args[0], args[1], args[2], args[3]));
    notifyListeners();
  }

  handleBeVisible(List<Object> args) {
    print("ULOGOVAN JE USER " + args[0]);
    onlineUsers.add(args[0]);
    if(requestedUsers.contains(args[0])) {
      requestedUsers.remove(args[0]);
    }
    notifyListeners();
  }

  handleUserOffline(List<Object> args) {
    print("USER " + args[0] + " JE SADA OFFLINE");
    onlineUsers.remove(args[0]);
    notifyListeners();
  }

  handleIsUserOnline(List<Object> args) {
    requestedUsers.add(args[0]);
    notifyListeners();
  }

}

class ChatMessageModel {
  String sender;
  String receiver;
  String message;
  DateTime date;

  ChatMessageModel(String s, String r, String m, String d) {
    sender = s;
    receiver = r;
    message = m;
    date = DateTime.parse(d);
  }
}