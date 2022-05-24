import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/auth/LoginPage.dart';
import 'package:kotarica/auth/SignupPage.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/home/HomeStranica.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/Footer.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:http/http.dart' as http;

String rememberUser;
bool zapamti = false;
TextEditingController userNameCtrl = TextEditingController();
TextEditingController passwordCtrl = TextEditingController();
TextEditingController firstNameCtrl = TextEditingController();
TextEditingController lastNameCtrl = TextEditingController();
TextEditingController emailCtrl = TextEditingController();
TextEditingController mobileCtrl = TextEditingController();
TextEditingController addressCtrl = TextEditingController();
TextEditingController addrssCtrl2 = TextEditingController();
TextEditingController passwordCtrl2 = TextEditingController();
TextEditingController firstNameCtrl2 = TextEditingController();
TextEditingController lastNameCtrl2 = TextEditingController();
TextEditingController emailCtrl2 = TextEditingController();
TextEditingController mobileCtrl2 = TextEditingController();

class ProfilePageData extends StatefulWidget {
  @override
  _ProfilePageDataState createState() => _ProfilePageDataState();
}

class _ProfilePageDataState extends State<ProfilePageData> {
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
    //getPref();
    //ucitajPodatke();
    return Scaffold(
      appBar: Header(),
      resizeToAvoidBottomInset: true,
      body: bodyContent(),
      //bottomNavigationBar: Footer(),
    );
  }

  Widget bodyContent() {
    var listM = Provider.of<UserModel>(context);
    var images = listM.pics;
    var i = 0;
    /*String p = passwordCtrl.text;
    String p1 = p.replaceAll("[", "");
    String p2 = p1.replaceAll("]", "");
    List<String> pass = p2.split(", ");
    List<int> lista = [];
    for (int i = 0; i < pass.length; i++) {
      lista.add(int.parse(pass[i]));
    }
    print("PASS " + lista.toString());
    //String s = utf8.decode(password);
    //print("SIFRA " + s);
    //List<int> password = pass.map((data) => int.parse(data)).toList();
    //print(password);
    //getPref();*/
    if (zapamti) {
      int br = listM.userCount;
      for (var i = 0; i < br; i++) {
        if (listM.users[i].userName == rememberUser) {
          userNameCtrl.text = listM.users[i].userName;
          passwordCtrl.text = listM.users[i].password;
          firstNameCtrl.text = listM.users[i].firstName;
          lastNameCtrl.text = listM.users[i].lastName;
          emailCtrl.text = listM.users[i].mail;
          mobileCtrl.text = listM.users[i].mobile;
          addressCtrl.text = listM.users[i].adresa;
          break;
        }
      }
    }
    return Material(
        child: FutureBuilder(
            future: getPref(),
            builder: (context, snapshot) {
              if (zapamti) {
                int br = listM.userCount;
                for (var i = 0; i < br; i++) {
                  if (listM.users[i].userName == rememberUser) {
                    userNameCtrl.text = listM.users[i].userName;
                    passwordCtrl.text = listM.users[i].password;
                    firstNameCtrl.text = listM.users[i].firstName;
                    lastNameCtrl.text = listM.users[i].lastName;
                    emailCtrl.text = listM.users[i].mail;
                    mobileCtrl.text = listM.users[i].mobile;
                    addressCtrl.text = listM.users[i].adresa;
                    break;
                  }
                }
              }
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
                            Container(
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 150, right: 150),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      color: Colors.orange[100],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Ime: ",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                firstNameCtrl.text,
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Novo ime: ",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                child: TextField(
                                                  //"Prezime:",
                                                  controller: firstNameCtrl2,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[150],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Prezime: ",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              lastNameCtrl.text,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Novo prezime: ",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                //"Prezime:",
                                                controller: lastNameCtrl2,
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[150],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      color: Colors.orange[100],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Adresa: ",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                addressCtrl.text,
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Nova adresa: ",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                child: TextField(
                                                  //"Prezime:",
                                                  controller: addrssCtrl2,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[150],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Mobilni telefon: ",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              mobileCtrl.text,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Novi broj telefona: ",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                //"Prezime:",
                                                controller: mobileCtrl2,
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[150],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      color: Colors.orange[100],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "E-mail: ",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  emailCtrl.text,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Nova e-mail adresa: ",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 200,
                                                  child: TextField(
                                                    //"Prezime:",
                                                    controller: emailCtrl2,
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[150],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            debugPrint(addrssCtrl2.text);
                                            listM.updateUser(
                                                rememberUser,
                                                passwordCtrl2.text,
                                                firstNameCtrl2.text,
                                                lastNameCtrl2.text,
                                                mobileCtrl2.text,
                                                emailCtrl2.text,
                                                addrssCtrl2.text);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeStranica()));
                                          },
                                          child: Text(
                                            "Izmeni podatke",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[800],
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  bottom: 20,
                                                  left: 50,
                                                  right: 50),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0)))),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 100)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )));
            }));
  }

  Widget imageProfile(BuildContext context, var listM, var images) {
    String hash = "";
    //debugPrint("images.length: "+images.length.toString());
    for (var i = 0; i < images.length; i++) {
      if (images[i].username == rememberUser) {
        hash = images[i].picHash;
        //debugPrint("Pronadjen hash!");
        //debugPrint("images[i].picHash = "+images[i].picHash);
      }
    }

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
            bottom: 20.0,
            right: 7.0,
            child: InkWell(
              onTap: () {
                importImage(ImageSource.gallery, listM);
              },
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 35.0,
                color: Colors.white70,
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
          )
        ],
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
