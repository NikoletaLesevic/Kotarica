import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/profile/profile.dart';
import 'package:kotarica/storage/getstorage.dart';

String rememberUser;
bool zapamti = false;

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getPref();
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      Icon(Icons.home),
                      Text('Početna', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                onPressed: () => {Navigator.of(context).pushNamed('/')}),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      Icon(CupertinoIcons.chat_bubble_2),
                      Text('Poruke', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                onPressed: () => {
                      if (rememberUser != null)
                        Navigator.of(context).pushNamed('/chats')
                      else
                        {
                          debugPrint("Morate biti ulogovani"),
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
                                  ))
                        }
                    }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 2),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      Icon(Icons.add),
                      Text('Novi oglas', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                onPressed: () => {
                      if (rememberUser != null)
                        Navigator.of(context).pushNamed('/prodaj')
                      else
                        {
                          debugPrint("Morate biti ulogovani"),
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
                                  ))
                        }
                    }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      Icon(CupertinoIcons.heart_solid),
                      Text(
                        'Lista želja',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop('/');
                                      Navigator.of(context).pushNamed('/login');
                                    },
                                    child: Text('OK'))
                              ],
                            ));
                  }
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7,
                      ),
                      Icon(Icons.person),
                      Text('Profil', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                onPressed: () {
                  if (rememberUser != null)
                    Navigator.of(context).pushNamed('/profil');
                  else
                    Navigator.of(context).pushNamed('/login');
                }),
          ],
        ),
      ),
    );
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
