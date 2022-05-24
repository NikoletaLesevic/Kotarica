import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/oglas/oglas.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeStranica.dart';
import 'package:http/http.dart' as http;

String rememberUser;
bool zapamti = false;
bool izvrsenaPromena = false;

class kratakPrikazOglasa extends StatefulWidget {
  final String kategorija;
  final String kratakOpis;
  final String slika;
  final double cena;
  final String imeProizvoda;
  final String vlasnik;
  bool daLiSamLajkovao = false;
  bool smeDaKomentarise;

  kratakPrikazOglasa(
      {Key key,
      this.kategorija,
      this.kratakOpis,
      this.slika,
      this.cena,
      this.imeProizvoda,
      this.vlasnik,
      this.smeDaKomentarise})
      : super(key: key);

  kratakPrikazOglasa.fromHome(
      {Key key,
      this.kategorija,
      this.kratakOpis,
      this.slika,
      this.cena,
      this.imeProizvoda,
      this.vlasnik,
      this.daLiSamLajkovao,
      this.smeDaKomentarise})
      : super(key: key);

  @override
  _kratakPrikazOglasaState createState() => _kratakPrikazOglasaState();
}

class _kratakPrikazOglasaState extends State<kratakPrikazOglasa> {
  Color heartColor;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      heartColor = widget.daLiSamLajkovao ? Colors.red : Colors.black26;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.daLiSamLajkovao) {
      // print("KRATAK PRIKAZ" + widget.daLiSamLajkovao.toString());
      if(!izvrsenaPromena) {
        setState(() {
          heartColor = Colors.red;
        });
      }
    }
    var listM = Provider.of<AdListModel>(context);
    getPref();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (Oglas(
                          name: widget.imeProizvoda,
                          price: widget.cena.toString(),
                          image: widget.slika,
                          description: widget.kratakOpis,
                          owner: widget.vlasnik,
                          category: widget.kategorija,
                          smeDaKomentarise: widget.smeDaKomentarise,
                        ))));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.orange[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                ]),
            height: 300,
            padding: EdgeInsets.all(8.0),
            //color: Colors.blueAccent,
            child: Column(
              children: [
                widget.slika != null
                    ? Image.network(
                        "${Config.IAMGE_URL}/${widget.slika}",
                        width: 150,
                        height: 140,
                      )
                    : Image.asset(
                        "images/maline.png",
                        width: 250,
                        height: 150,
                      ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              child: Center(
                                  child: Text(
                        this.widget.imeProizvoda,
                        style: TextStyle(fontSize: 20),
                      )))),
                      Expanded(
                          child: Container(
                              child: Center(
                                  child: Text(
                        this.widget.kratakOpis,
                        style: TextStyle(fontSize: 13),
                      )))),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              child: Text(
                            this.widget.cena.toString() + ' din.',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )))
                    ],
                  ),
                ),
                rememberUser == this.widget.vlasnik
                    ? ElevatedButton(
                        onPressed: () async {
                          await listM.removeAd(
                              this.widget.imeProizvoda, this.widget.vlasnik);
                          Navigator.of(context).pop('/');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeStranica()));
                        },
                        child: Icon(Icons.delete_forever),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange[100],
                            shadowColor: Colors.transparent)
                      )
                    : ElevatedButton(
                        child: Icon(
                          CupertinoIcons.heart_solid,
                          color: heartColor,
                          size: 35,
                        ),
                        onPressed: () async {
                          if (rememberUser != null) {
                            // await listM.addWish(rememberUser, widget.vlasnik, widget.imeProizvoda);
                            setState(() {
                              heartColor = heartColor == Colors.red
                                  ? Colors.black26
                                  : Colors.red;
                            });
                            if (heartColor == Colors.red) {
                              await http.post(
                                Uri.parse("${Config.BACKEND_REST}/api/wish"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader:
                                      "Basic your_api_token_here"
                                },
                                body: jsonEncode(<String, dynamic>{
                                  "username": rememberUser,
                                  "adOwner": widget.vlasnik,
                                  "adName": widget.imeProizvoda,
                                }),
                              );
                            } else {
                              print("BRISEEEEEMM");
                              http.delete(
                                  "${Config.BACKEND_REST}/api/wish/delete/" +
                                      rememberUser +
                                      "/" +
                                      widget.imeProizvoda);
                              print("${Config.BACKEND_REST}/api/wish/delete/" +
                                  rememberUser +
                                  "/" +
                                  widget.imeProizvoda);
                            }

                            //Navigator.of(context).pop('/');
                            // if(context.toString() == 'wishlist') {
                            //   Navigator.of(context)
                            //       .push(MaterialPageRoute(builder: (context) => HomeStranica()));
                            //   Navigator.of(context).pushNamed('/wishlist');
                            // }
                            // else
                            //   Navigator.of(context).pushNamed('/wishlist');

                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                        content: Text(
                                          'Morate biti ulogovani da biste dodali nesto u listu zelja',
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
                                        ]));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange[100],
                            shadowColor: Colors.transparent),
                      )
                /*rememberUser == this.vlasnik ?
                  HoverButton(onpressed:() {},
                  hoverTextColor: Colors.black,
                  child: Icon(Icons.delete_forever),
                  ) : Text('')*/
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

getPref() {
  GetStorageHelper gh = new GetStorageHelper();
  var user = gh.readUsername();
  rememberUser = user;
  if (user != null) {
    zapamti = true;
  }
}
