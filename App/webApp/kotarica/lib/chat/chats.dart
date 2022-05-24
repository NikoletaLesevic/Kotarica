import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/chat_users.dart';
import 'package:kotarica/chat/chat.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/MessageModel.dart';
import 'package:http/http.dart' as http;
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String rememberUser;
bool zapamti=false;


class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<ChatMessageModel> users = [];
  bool isLoading = false;

  @override
  void initState() {

    super.initState();
    this.fetchUsers();
  }

  fetchUsers() async {
    getPref();
    setState(() {
      isLoading = true;
    });

    String url = "${Config.BACKEND_REST}/api/messages/" + rememberUser;
    var response = await http.get(url);
    if(response.statusCode == 200) {
      var items = json.decode(response.body);
      List<ChatMessageModel> helpList = [];
      for(int i=0; i<items.length; i++) {
        helpList.add(ChatMessageModel(items[i]["sender"], items[i]["receiver"], items[i]["message"], items[i]["date"]));
      }
      setState(() {
        users = helpList;
        isLoading = false;
      });
    } else {
      users = [];
      isLoading = false;
    }
    print(users);
  }

  getPref()  {
    GetStorageHelper gh = new GetStorageHelper();
    var user = gh.readUsername();
    rememberUser = user;
    if(user != null) {
      zapamti=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Moje poruke",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        //actions: [Icon(Icons.search)],
      ),
      body:isLoading ? Center(child: CircularProgressIndicator()) : ChatUsers(users, rememberUser),
    );
  }
}



