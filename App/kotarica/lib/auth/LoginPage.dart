import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/profile/profile_data.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/auth/SignupPage.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:signalr_client/hub_connection.dart';
// import 'package:kotarica/signup_strana/signup_strana.dart';

import '../home/HomeStranica.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: Header(),
      body: bodyContent(context),
    );
  }

  refresh() {}
}

Widget bodyContent(BuildContext context) {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  var listM = Provider.of<UserModel>(context);
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(25),
      child: responsive_login(usernameCtrl, passwordCtrl, context, listM),
    ),
  );
}

Widget responsive_login(TextEditingController usernameCtrl,
    TextEditingController passwordCtrl, BuildContext context, UserModel listM) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        height: 70.0,
      ),
      Text(
        "Korisničko ime:",
        style: TextStyle(fontSize: 17.0),
        textAlign: TextAlign.left,
      ),
      TextField(
        controller: usernameCtrl,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            prefixIcon: Icon(Icons.person)),
      ),
      SizedBox(height: 30.0),
      Text(
        "Lozinka:",
        style: TextStyle(fontSize: 17.0),
        textAlign: TextAlign.left,
      ),
      TextField(
        controller: passwordCtrl,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            prefixIcon: Icon(Icons.vpn_key_rounded)),
        obscureText: true,
      ),
      SizedBox(height: 30.0),
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 230.0,
            child: ElevatedButton(
              onPressed: () async {
                debugPrint(context.toString());
                var i = await listM.checkUserZaLogin(
                    usernameCtrl.text, passwordCtrl.text);
                debugPrint(i.toString());
                if (i.toString() == "Postoji i tacna lozinka") {
                  var pref = await SharedPreferences.getInstance();
                  var signalR =
                      Provider.of<SignalHelper>(context, listen: false);
                  if (signalR.hubConnection.state !=
                      HubConnectionState.Disconnected) {
                    signalR.goOnline(usernameCtrl.text);
                  }
                  pref.setString('userName', usernameCtrl.text);
                  GetStorageHelper gh = new GetStorageHelper();
                  gh.addUsername(usernameCtrl.text);
                  gh.addPassword(base64Encode(utf8.encode(passwordCtrl.text)));
                  await listM.getPics();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeStranica()));
                } else {
                  debugPrint("Pogresna kombinacija");
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: Text(
                                'Pogresna kombinacija korisnicko ime/lozinka'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'))
                            ],
                          ));
                }
              },
              child: Text(
                "Prijavi se",
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange[200],
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 180.0,
      ),
      ElevatedButton(
        onPressed: () async {
          listM.getPics();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignInPage()));
        },
        child: Text(
          "Napravi novi nalog",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[300],
            padding: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      ),
      SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
        onPressed: () async {
          await listM.getPics();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeStranica()));
        },
        child: Text(
          "Nastavi bez prijavljivanja",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[400],
            padding: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      ),
    ],
  );
}
