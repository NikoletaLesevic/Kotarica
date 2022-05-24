import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/filteri/dropDown/dropDownKategorije.dart';
import 'package:kotarica/filteri/filteriZaPretragu.dart';
import 'package:kotarica/home/mobile_list.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/auth/LoginPage.dart';
import 'package:http/http.dart' as http;
import '../filteri/forma.dart';

String rememberUser;
bool zapamti = false;

class HomeStranica extends StatefulWidget {
  HomeStranica({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => StanjeHomeStranice();
}

class StanjeHomeStranice extends State<HomeStranica> {
  //Definise stanje i izgled home stranice
  String _searchState = "";

  odabraniFilteri odabrani; //Sadrzi filtere koje je korisnik odabrao

  Set<String> myWishList = new Set();

  @override
  void initState() {
    fetchData();
  }

  void fetchData() async {
    print("HVATAM PODATKE");
    Set<String> tempSet = new Set();
    getPref();
    if (zapamti && rememberUser != null) {
      String url = "${Config.BACKEND_REST}/api/wish/" + rememberUser;
      print("URL JE " + url);
      var response = await http.get(url);

      var items = json.decode(response.body);
      print("DOBIJEN JE RESPONSE " + items.length.toString());
      for (int i = 0; i < items.length; i++) {
        tempSet.add(items[i]["adName"]);
      }

      setState(() {
        myWishList = tempSet;
      });
    }
  }

  void refresh() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }

  Future refreshOnPull() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }

  String _kategorija = 'Sve kategorije';

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<AdListModel>(context);
    List listOfAds = [];

    if (!listModel.isLoading) {
      for (int index = 0; index < listModel.ads.length; index++) {
        if (listModel.ads[index].name
                .toLowerCase()
                .contains(_searchState.toString().toLowerCase()) &&
            (odabrani == null ||
                (double.parse(listModel.ads[index].price) >=
                        odabrani.okvirCena.start &&
                    double.parse(listModel.ads[index].price) <=
                        odabrani.okvirCena.end &&
                    listModel.ads[index].name
                        .toLowerCase()
                        .contains(_searchState.toString().toLowerCase()))) && (_kategorija== 'Sve kategorije' || _kategorija==listModel.ads[index].category) ){
          listOfAds.add(listModel.ads[index]);
        }
      }
    }

    var signalR = Provider.of<SignalHelper>(context);
    signalR.startConnection();
    getPref();
    print(_searchState);
    return Scaffold(
      appBar: Header(),
      endDrawer: MyDrawer(),
      bottomNavigationBar: Footer(),
      body: listModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refreshOnPull,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        color: Colors.orange[700],
                        child: SizedBox(
                          height: 130,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                //Pretraga

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                width: 320,
                                height: 60,
                                padding: EdgeInsets.all(16.0),
                                //color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        //Unos pretrage

                                        decoration: InputDecoration(
                                          icon: Icon(Icons.search),
                                          hintText: 'Termin pretrage ',
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          // pretrazi(value);
                                          setState(() => _searchState = value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(

                                    //Dugmici za kategorije i filtere

                                    child: Row(
                                  children: <Widget>[
                                     IntrinsicHeight(
                                        child: ElevatedButton(
                                          //Dugme za kategorije
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.orange[700],
                                            elevation: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/categoriesIcon.png',
                                                width: 48,
                                                height: 25,
                                              ),
                                              //Text('  Kategorije'),
                                              //SizedBox(width: 10,),
                                  Container(
                                    padding: const EdgeInsets.all(0.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(

                                          value: _kategorija,
                                          elevation: 5,
                                          style: TextStyle(color: Colors.white),
                                          iconEnabledColor: Colors.black,

                                          items:<String>[
                                            'Sve kategorije',
                                            'Meso i mesne preradjevine',
                                            'Mleko i mlecni proizvodi',
                                            'Voce',
                                            'Povrce',
                                            'Bilje i gljive',
                                            'Dzem',
                                            'Ajvar',
                                            'Med',
                                            'Ulje',
                                            'Namaz',
                                            'Slatkisi',
                                            'Vino',
                                            'Rakija',
                                            'Domaci sok',
                                            'Caj',
                                            'Odeća i proizvodi od tekstila',
                                            'Kozmetika i sredstva za higijenu',
                                            'Namestaj',
                                            'Korpe',
                                            'Cvece',
                                            'Ostalo',
                                          ].map <DropdownMenuItem<String>>((String value)
                                          {
                                            return DropdownMenuItem<String>
                                              (
                                              value: value,
                                              child: SizedBox(width:180,child: Text(value,style: TextStyle(color: Colors.black,fontFamily: 'Fantasy',fontSize: 18),)),
                                            );
                                          }).toList(),

                                          onChanged: (String value) {
                                            setState(() {
                                              _kategorija = value;
                                            });
                                          }

                                      ),
                                    ),
                                  )
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),

                                    Container(
                                      width: 1,
                                      height: 35,
                                      color: Colors.black26,
                                    ),
                                    IntrinsicHeight(
                                      child: ElevatedButton(
                                        //Dugme za filtere
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.orange[700],
                                            elevation: 0),
                                        child: Row(
                                          //mainAxisAlignment:
                                             // MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/filterIcon.png',
                                              width: 50,
                                              height: 25,
                                            ),
                                            Text('  Filteri'),
                                          ],
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FilteriZaPretragu(),
                                              ));
                                          setState(() {
                                            odabrani = result;
                                          });

                                          //print(odabrani.toString());
                                        },
                                      ),
                                    ),
                                    // Expanded(child: Text(zapamti ? "Zdravo, $rememberUser !" : "Dobro dosli!", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Svi oglasi",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                    Expanded(
                      child: new MobileList(listModel, listOfAds, myWishList),
                    ),
                  ],
                ),
              ),
            ),
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
