import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/profile/my_ads.dart';
import 'package:kotarica/profile/profile_data.dart';
import 'package:kotarica/profile/sveKupljeno.dart';
import 'package:kotarica/profile/sveProdato.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:kotarica/wallet/wallet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

String rememberUser;
bool zapamti = false;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String error;
  Uint8List data;

  pickImage(var listM) {
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) async {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        List<int> list = base64.decode(stripped).cast();
        var res =
            await uploadImage(input.files[0].name, list, Config.BACKEND_IMAGE);
        listM.addPic(rememberUser, res.toString());
        //debugPrint("res.toString je : "+res.toString());
        debugPrint("DODATA SLIKA !");

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  Future importImage(ImageSource source, var listM) async {
    pickImage(listM);
  }

  Future<String> uploadImage(filename, list, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //request.files.add(await http.MultipartFile.fromPath('image', filename));
    request.files.add(
        await http.MultipartFile.fromBytes('image', list, filename: filename));
    http.Response response =
        await http.Response.fromStream(await request.send());

    print("Result: ${response.statusCode}");

    return response.body;
    // var res = await request.send();
    // print(res.toString());
    // print(res.)
    // return res.reasonPhrase;
  }

  @override
  Widget build(BuildContext context) {
    //GetStorageHelper gh = new GetStorageHelper();
    //print("Korisnik je " + gh.readUsername());
    getPref();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: Header(),
      endDrawer: MainDrawer(),
      body: bodyContent(),
      //bottomNavigationBar: Footer(),
    );
  }

  Widget bodyContent() {
    return Material(
        child: FutureBuilder(
            future: getPref(),
            builder: (context, snapshot) {
              //getPref();
              var listModel = Provider.of<AdListModel>(context);
              var listM = Provider.of<UserModel>(context);
              var listModell = Provider.of<NotificationListModel>(context);
              var images = listM.pics;
              //listM.getPics();

              return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.orange[800],
                        Colors.amber[400],
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 100, right: 100),
                      //future: getPref(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(300),
                              topRight: Radius.circular(300)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 250.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 20.0),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      imageProfile(context, listM, images)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    zapamti ? rememberUser : "@korisnickoime",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/prodaj');
                                        }, //OVDE POVEZATI SA STRANOM ZA DODAVANJE OGLASA
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "+  Dodaj novi oglas",
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.orange,
                                            padding: EdgeInsets.only(
                                                top: 15,
                                                bottom: 15,
                                                left: 40,
                                                right: 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)))),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 250, right: 250),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePageData()));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Moji podaci",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[100],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => (MyAds(
                                                          listModel: listModel,
                                                          rememberUser:
                                                              rememberUser))));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Moji oglasi",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[200],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          (sveProdato(
                                                              listModel:
                                                                  listModell,
                                                              rememberUser:
                                                                  rememberUser))));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Prodati proizvodi",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[300],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          (sveKupljeno(
                                                              listModel:
                                                                  listModell,
                                                              rememberUser:
                                                                  rememberUser))));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Kupljeni proizvodi",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[400],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed('/wishlist');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Lista želja",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[500],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed('/chats');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  "Poruke",
                                                  style: TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[600],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 15),
                                            )),
                                        SizedBox(
                                          height: 100,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )));
            }));
  }

  Widget imageProfile(BuildContext context, var listM, var images) {
    //var hashProfilneSlike = listM.returnPicHash(rememberUser);
    //hashProfilneSlike.toString() != "Nije dodeljena slika" ? debugPrint("Dobar je hash") : debugPrint("Nije dodeljena slika (HASH)");

    String hash = "";
    //debugPrint("images.length: "+images.length.toString());
    for (var i = 0; i < images.length; i++) {
      if (images[i].username == rememberUser) {
        hash = images[i].picHash;
        //debugPrint("Pronadjen hash!");
        //debugPrint("images[i].picHash = "+images[i].picHash);
      }
    }
    //debugPrint("hash: "+hash);

    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: hash != ""
              ? Image.network(
                  "${Config.IAMGE_URL}/${hash}",
                  width: 100,
                  height: 100,
                ).image
              : AssetImage("images/profile.png"),
        ),
        Positioned(
            bottom: 1.0,
            right: 1.0,
            child: InkWell(
              onTap: () {
                importImage(ImageSource.gallery, listM);
              },
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 35.0,
                color: Colors.grey[700],
              ),
            ))
      ],
    );
  }

  Widget bottomSheet(BuildContext context, var listM) {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "Izaberi profilnu fotografiju",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  importImage(ImageSource.camera, listM);
                },
                icon: Icon(Icons.camera),
                label: Text("Kamera"),
              ),
              TextButton.icon(
                onPressed: () {
                  importImage(ImageSource.gallery, listM);
                },
                icon: Icon(Icons.image),
                label: Text("Galerija"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

getPref() async {
  var pref = await SharedPreferences.getInstance();
  var user = pref.getString('userName');
  rememberUser = user;
  if (user != null) {
    zapamti = true;
  }
  UsersWallet usersWallet = new UsersWallet(user);
  usersWallet.getAdress();
}
