import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/profile/profile_data.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:kotarica/wallet/wallet.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/auth/SignupPage.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/shared/responsive_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:web3dart/credentials.dart';
// import 'package:kotarica/signup_strana/signup_strana.dart';

import '../home/HomeStranica.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: bodyContent(context),
    );
  }

  refresh() {}
}

Widget bodyContent(BuildContext context) {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  var listM = Provider.of<UserModel>(context);
  return Container(
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.orange[800],
                    Colors.amber[400],
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(400),
                    bottomRight: Radius.circular(400))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/basket.png',
                  width: 170,
                  height: 170,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "KOTARICA",
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/plant.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    Text(
                      "Biraj zdravlje, biraj prirodu, biraj kotaricu.",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
              padding:
                  EdgeInsets.only(top: 30, left: 100, right: 100, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:
                  responsive_login(usernameCtrl, passwordCtrl, context, listM)),
        ),
      ],
    ),
  );
}

Widget responsive_login(TextEditingController usernameCtrl,
    TextEditingController passwordCtrl, BuildContext context, UserModel listM) {
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  var notModel = Provider.of<NotificationListModel>(context);
  String privateKey;
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: ExactAssetImage(
                    'images/avatar.png',
                  ),
                )),
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "Korisničko ime:",
        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      Container(
        width: 400,
        child: TextField(
          controller: usernameCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              prefixIcon: Icon(Icons.person)),
        ),
      ),
      SizedBox(height: 30.0),
      Text(
        "Lozinka:",
        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      Container(
        width: 400,
        child: TextField(
          controller: passwordCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              prefixIcon: Icon(Icons.vpn_key_rounded)),
          obscureText: true,
        ),
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
                debugPrint("PREEEE");
                var i = await listM.checkUserZaLogin(
                    usernameCtrl.text, passwordCtrl.text);
                debugPrint("POSLEEE");
                debugPrint(i.toString());
                if (i.toString() == "Postoji i tacna lozinka") {
                  var pref = await SharedPreferences.getInstance();
                  var signalR =
                      Provider.of<SignalHelper>(context, listen: false);
                  if (signalR.hubConnection.state !=
                      HubConnectionState.disconnected) {
                    signalR.goOnline(usernameCtrl.text);
                  }
                  pref.setString('userName', usernameCtrl.text);
                  GetStorageHelper gh = new GetStorageHelper();
                  gh.addUsername(usernameCtrl.text);
                  gh.addPassword(base64Encode(utf8.encode(passwordCtrl.text)));

                  Alert(
                    context: context,
                    title:
                    "Unesite privatni ključ Vašeg Ethereum naloga,\nukoliko ne unesete, opcija plaćanja kriptovalutom Vam neće biti dostupna.",
                    content: Form(
                      key: formKey2,
                      child: TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Prazno polje";
                        },
                        onSaved: (String value) {
                          privateKey = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      ),
                    ),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style:
                          TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          if (formKey2.currentState.validate()) {
                            print("DAJAJAJAJAJAJJAA");
                            formKey2.currentState.save();

                            //listModel.addPrivateKey(_privateKey);
                            showAlertDialog(context);
                            debugPrint("Dodat private key" + privateKey);
                            //listModel.addPrivateKey(_privateKey);
                            // showAlertDialog(context);
                            debugPrint("Dodat private key" + privateKey);




                            UsersWallet usersWallet =
                            new UsersWallet(usernameCtrl.text);
                            //username = _userName;
                            await usersWallet.writeWallet(privateKey);
                            EthereumAddress public =
                            await usersWallet.getAdress();
                            await notModel.createWallet(
                                usernameCtrl.text, true, public.toString());
                            await listM.getPics();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeStranica()));
                          }
                        },

                        color: Colors.orange[400],
                      ),
                      DialogButton(
                        child: Text(
                          "Nastavi bez ključa",
                          style:
                          TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          // showAlertDialog(context);
                          listM.getPics();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => HomeStranica()));
                        },
                        color: Colors.orange[400],
                      ),
                      DialogButton(
                          child: Text(
                            'Šta je Ethereum nalog?',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: Text(
                                      'Ethereum nalog predstavlja nalog na globalnoj Ethereum mreži, koji omogućava izvršavanje transakcija.\nSvi podaci na ovoj mreži su enkriptovani i bezbedno se čuvaju, a svaka transakcija je vidljiva svim korisnicima.\nUkoliko nemate kreiran nalog, a želite da kupujete kriptovalutom, preporučujemo sajt myetherwallet.com',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'))
                                  ],
                                ));
                          },
                          color: Colors.orange[400])
                    ],
                  ).show();


                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => HomeStranica()));
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
                  primary: Colors.orange[800],
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 100.0,
      ),
      SizedBox(
        height: 45,
        width: 350,
        child: ElevatedButton(
          onPressed: () async {
            await listM.getPics();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignInPage()));
          },
          child: Text(
            "Napravi novi nalog",
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue[300],
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)))),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      SizedBox(
        height: 45,
        width: 350,
        child: ElevatedButton(
          onPressed: () async {
            await listM.getPics();
            Navigator.of(context).pop('/');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeStranica()));
          },
          child: Text(
            "Nastavi bez prijavljivanja",
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue[300],
              padding: EdgeInsets.all(11.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)))),
        ),
      ),
    ],
  );
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.orange,
    title: Center(
      child: Text(
        "Kreiranje walleta...",
        style: TextStyle(fontSize: 26, color: Colors.white),
      ),
    ),
    content: SizedBox(
      height: 200,
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          //backgroundColor: Colors.orange,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 6,
        ),
      ),
    ),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
