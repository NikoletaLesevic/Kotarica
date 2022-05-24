import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/WishModel.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

String rememberUser;
bool zapamti = false;

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //getPref();
    var listModel = Provider.of<AdListModel>(context);
    List<WishModel> mojeZelje = [];
    return Material(
        child: FutureBuilder(
            future: getPref(mojeZelje),
            builder: (context, snapshot) {
              debugPrint("Moje zelje " + mojeZelje.length.toString());

              List<Ad> oglasi = [];
              for (var i = 0; i < mojeZelje.length; i++) {
                //debugPrint(mojeZelje[i].adName + " " + mojeZelje[i].adOwner);
                for (var j = 0; j < listModel.allAds.length; j++) {
                  if (listModel.allAds[j].name == mojeZelje[i].adName &&
                      listModel.allAds[j].user == mojeZelje[i].adOwner)
                    oglasi.add(Ad(
                        category: listModel.allAds[j].category,
                        name: listModel.allAds[j].name,
                        user: listModel.allAds[j].user,
                        price: listModel.allAds[j].price,
                        picHash: listModel.allAds[j].picHash,
                        contact: listModel.allAds[j].contact,
                        description: listModel.allAds[j].description));

                  debugPrint(oglasi.length.toString());
                  //debugPrint(oglasi[i].name + " " + oglasi[i].user);
                }
              }
              debugPrint("OGLASI:");
              debugPrint(oglasi.length.toString());
              for (var i = 0; i < oglasi.length; i++) {
                debugPrint(oglasi[i].name + " " + oglasi[i].user);
              }

              return Scaffold(
                backgroundColor: Colors.white,
                endDrawer: MainDrawer(),
                appBar: Header(),
                bottomNavigationBar: Footer(),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          "Lista želja",
                          style: TextStyle(
                              fontSize: 28.0,
                              color: Color(0xff480355),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: //Text('PROBA')
                            ListView.builder(

                                //Deo sa oglasima

                                itemCount: oglasi.length, //oglasi.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(listModel.ads[index].name.toLowerCase());

                                  return kratakPrikazOglasa.fromHome(
                                    kategorija: oglasi[index].category,
                                    kratakOpis: oglasi[index].description,
                                    slika: oglasi[index].picHash,
                                    imeProizvoda: oglasi[index].name,
                                    cena: double.parse(oglasi[index].price),
                                    vlasnik: oglasi[index].user,
                                    daLiSamLajkovao: true,
                                  );
                                }),
                      ),
                    ]),
              );
            }));
  }
}

getPref(List<WishModel> myWishes) async {
  GetStorageHelper gh = new GetStorageHelper();
  var user = gh.readUsername();
  rememberUser = user;
  if (user != null) {
    zapamti = true;
  }

  if (zapamti) {
    String url = "${Config.BACKEND_REST}/api/wish/" + rememberUser;
    var response = await http.get(url);

    var items = json.decode(response.body);
    print("DOBIJEN JE RESPONSE " + items.length.toString());
    for (int i = 0; i < items.length; i++) {
      myWishes.add(WishModel(
          username: items[i]["username"],
          adName: items[i]["adName"],
          adOwner: items[i]["adOwner"]));
    }
  }
}
