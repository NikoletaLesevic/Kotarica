import 'dart:io';

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
import 'package:kotarica/shared/Footer.dart';
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
  PickedFile imageFile;

  Future importImage(ImageSource source, var listM) async {
    PickedFile picture = await ImagePicker().getImage(source: source);
    if (picture != null) {
      imageFile = picture;

      // ovde treba da se sacuva slika na Ethereum-u
      // print("${Config.BACKEND_IMAGE}/upload");
      var res = await uploadImage(imageFile.path, Config.BACKEND_IMAGE);
      listM.addPic(rememberUser, res.toString());
      //debugPrint("res.toString je : "+res.toString());
      debugPrint("DODATA SLIKA !");
    }
    setState(() {
      getPref();
    });
  }

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filename));
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      bottomNavigationBar: Footer(),
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
              //listM.getPics();
              var images = listM.pics;
              return SingleChildScrollView(
                  child: Container(
                      //future: getPref(),
                      child: Column(
                children: [
                  Container(
                    height: 300.0,
                    color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 50.0),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [imageProfile(context, listM, images)],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          zapamti ? rememberUser : "@korisnickoime",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePageData()));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Moji podaci",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.grey[800]),
                                  textAlign: TextAlign.start,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                )
                              ]),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/prodaj');
                          }, //OVDE POVEZATI SA STRANOM ZA DODAVANJE OGLASA
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dodaj novi oglas",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.grey[800]),
                                textAlign: TextAlign.start,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              )
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => (MyAds(
                                          listModel: listModel,
                                          rememberUser: rememberUser))));
                            },
                            child: Text(
                              "Moji oglasi",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[100],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => (sveProdato(
                                          listModel: listModell,
                                          rememberUser: rememberUser))));
                            },
                            child: Text(
                              "Prodati proizvodi",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[200],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => (sveKupljeno(
                                          listModel: listModell,
                                          rememberUser: rememberUser))));
                            },
                            child: Text(
                              "Kupljeni proizvodi",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ))
                      ],
                    ),
                  ),
                ],
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
          /*
          backgroundImage: hashProfilneSlike.toString() != "Nije dodeljena slika" ?
          Image.network(
            "https://ipfs.io/ipfs/$hashProfilneSlike",
            width: 100,
            height: 100,
          ).image
          //AssetImage("images/avatar.png")
              : AssetImage("images/profile.png"),
          */
          /*
          backgroundImage: imageFile == null
              ? AssetImage("images/profile.png")
              : FileImage(File(imageFile.path)),
              */
        ),
        Positioned(
            bottom: 1.0,
            right: 1.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet(context, listM)));
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
  //UsersWallet usersWallet = new UsersWallet(user);
  //usersWallet.getAdress();
}
