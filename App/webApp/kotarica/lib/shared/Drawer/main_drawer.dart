import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/model/obavestenje.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'MojaObavestenja.dart';

String rememberUser;
bool zapamti = false;

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int myIndex;
  PageController _controller; //Za promenu stranica

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  _onChangePage(int index) {
    if (index != 0)
      setState(() {
        myIndex = index;
      });
    _controller.animateToPage(index.clamp(0, 1),
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: Drawer(
        child: PageView.builder(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0)
              return MainDrawer(
                obavestenja: () => _onChangePage(1),
              );
            switch (myIndex) {
              case 1:
                return MojaObavestenja(
                    goBack: () => _onChangePage(0), rememberUser: rememberUser);
            }
          },
        ),
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  final VoidCallback obavestenja;

  MainDrawer({this.obavestenja});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: getPref(),
            builder: (context, snapshot) {
              //getPref();
              var listM = Provider.of<UserModel>(context);

              // DEO ZA UCITAVANJE SLIKE
              var listModelUser = Provider.of<UserModel>(context);
              var images = listM.pics;
              String hash = "";
              for (var i = 0; i < images.length; i++) {
                if (images[i].username == rememberUser)
                  hash = images[i].picHash;
              }

              String ime = "Ime";
              String prezime = "Prezime";
              if (rememberUser != null) {
                for (var i = 0; i < listM.userCount; i++) {
                  if (listM.users[i].userName == rememberUser) {
                    ime = listM.users[i].firstName;
                    prezime = listM.users[i].lastName;
                    break;
                  }
                }
              }
              return Drawer(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(
                                top: 30,
                                bottom: 20,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: hash != ""
                                        ? Image.network(
                                            "${Config.IAMGE_URL}/${hash}",
                                          ).image
                                        : ExactAssetImage('images/avatar.png'),
                                    //image: ExactAssetImage('images/avatar.png'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Text(ime + ' ' + prezime,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white)),
                            Text(
                              rememberUser != null ? rememberUser : 'Username',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Početna', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        Navigator.of(context).pushNamed('/');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Profil', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        if (rememberUser != null)
                          Navigator.of(context).pushNamed('/profil');
                        else
                          Navigator.of(context).pushNamed('/login');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add),
                      title:
                          Text('Postavi oglas', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        if (rememberUser != null)
                          Navigator.of(context).pushNamed('/prodaj');
                        else {
                          debugPrint("Morate biti ulogovani");
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text(
                                      'Morate biti ulogovani da biste postavili oglas',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop('/');
                                            Navigator.of(context)
                                                .pushNamed('/login');
                                          },
                                          child: Text('OK'))
                                    ],
                                  ));
                          // Navigator.of(context).pushNamed('/login');
                        }
                        /*
                        if (rememberUser != null)
                          Navigator.of(context).pushNamed('/prodaj');
                        else
                          Navigator.of(context).pushNamed('/login');*/
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.heart_solid),
                      title:
                          Text('Lista želja', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        if (rememberUser != null)
                          Navigator.of(context).pushNamed('/wishlist');
                        else {
                          debugPrint("Morate biti ulogovani");
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text(
                                      'Morate biti ulogovani da biste pristupili listi želja',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop('/');
                                            Navigator.of(context)
                                                .pushNamed('/login');
                                          },
                                          child: Text('OK'))
                                    ],
                                  ));
                          // Navigator.of(context).pushNamed('/login');
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.chat_bubble_2),
                      title: Text('Poruke', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        if (rememberUser != null)
                          Navigator.of(context).pushNamed('/chats');
                        else {
                          debugPrint("Morate biti ulogovani");
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text(
                                      'Morate biti ulogovani da biste pristupili porukama',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop('/');
                                            Navigator.of(context)
                                                .pushNamed('/login');
                                          },
                                          child: Text('OK'))
                                    ],
                                  ));
                          // Navigator.of(context).pushNamed('/login');
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title:
                          Text('Obaveštenja', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        if(rememberUser == null) {
                          showDialog(
                            context: context,
                              builder: (_) => AlertDialog(
                                content: Text(
                                  'Morate biti ulogovani da biste pristupili obaveštenjima',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop('/');
                                        Navigator.of(context)
                                            .pushNamed('/login');
                                      },
                                      child: Text('OK'))
                                ],
                              )
                          );
                        }
                        else {
                          obavestenja();
                        }

                      }
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                          rememberUser != null ? 'Odjavi se' : 'Prijavi se',
                          style: TextStyle(fontSize: 18)),
                      onTap: () async {
                        GetStorageHelper gh = new GetStorageHelper();
                        gh.logout();
                        if (rememberUser != null) {
                          var signalR =
                              Provider.of<SignalHelper>(context, listen: false);
                          signalR.goOffline(rememberUser);
                          var pref = await SharedPreferences.getInstance();
                          // pref.setString('userName', '');
                          pref.remove('userName');
                          zapamti = false;
                          Navigator.of(context).pushNamed('/');
                        } else
                          Navigator.of(context).pushNamed('/login');
                      },
                    ),
                  ],
                ),
              );
            }));
    ;
  }
}

getPref() async {
  GetStorageHelper gh = new GetStorageHelper();
  var user = gh.readUsername();
  rememberUser = user;
  if (user != null) {
    zapamti = true;
  }
}
