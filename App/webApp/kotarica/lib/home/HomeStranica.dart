// import 'package:connect/contract/model/AdModel.dart';
// import 'package:connect/home/KratakPrikazOglasa.dart';
// import 'package:connect/main.dart';
// import 'dart:html';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/filteri/filteriZaPretragu.dart';
import 'package:kotarica/home/desktop_grid.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/model/WishModel.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:kotarica/shared/responsive_helper.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/shared/responsive_helper.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/auth/LoginPage.dart';

import '../filteri/forma.dart';
import 'package:http/http.dart' as http;

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

  // Potrebno za filtere
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool sacuvaniFilteri = false;
  String _kategorija = "Izaberi kategoriju";
  String _cenaMin = "0";
  String _cenaMax = "999999";
  bool _mogucnostRezervacije = false;
  String _getCb() {
    if(_mogucnostRezervacije == true) { return 'Da'; }
    else { return 'Ne'; }
  }

  Set<String> myWishList = new Set();

  @override
  void initState() {
    fetchData();
  }

  void fetchData() async {
    print("HVATAM PODATKE");
    Set<String> tempSet = new Set();
    getPref();
    if(zapamti) {
      String url = "${Config.BACKEND_REST}/api/wish/" + rememberUser;
      print("URL JE " + url);
      var response = await http.get(url);

      var items = json.decode(response.body);
      print("DOBIJEN JE RESPONSE " + items.length.toString());
      for(int i=0; i<items.length; i++) {
        tempSet.add(items[i]["adName"]);
      }

      setState(() {
        myWishList = tempSet;
      });
      print("SETOVAOOOO");
    }
  }

  Widget _buildKategorija() {
    return Container(
      //height: 50,
        width: 280,
        child : DropdownButtonFormField<String>(
          value: _kategorija,
          hint: Text('Izaberi kategoriju'),
          dropdownColor: Colors.orange,
          style: TextStyle(fontSize: 16, color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          items: <String>[
            'Izaberi kategoriju',
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
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
              //child: SizedBox(width: 180,child: Center(child: Text(value,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontFamily: 'Fantasy',fontSize: 20),))),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              _kategorija = value;
            });
          },
        )
    );
  }

  Widget _buildCenaMin() {
    return Container(
        width: 280,
        child : TextFormField(
          inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter((5))],
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 18, color: Colors.white),
          decoration: InputDecoration(
              enabledBorder: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0)),
              focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),)
          ),
          validator: (String value){
            int cena = int.tryParse(value);
            //if(value.isEmpty){
            //  return 'Unesite cenu';
            //}
            if(value.isNotEmpty && !RegExp(r"^[0-9]*$").hasMatch(value)) {
              return 'Unesite validnu cenu';
            }
            if(value.isNotEmpty && (cena<0)){
              return 'Cena mora biti pozitivna';
            }
            if(value.isNotEmpty && (_cenaMax!=null && cena > int.tryParse(_cenaMax))){
              return 'Mora biti manja od maksimalne cene';
            }
            return null;
          },
          onSaved: (String value){
            if(value.isNotEmpty) _cenaMin = value;
            else if(value.isEmpty) _cenaMin = "0";
          },
        )
    );
  }

  Widget _buildCenaMax() {
    return Container(
        width: 280,
        child : TextFormField(
          inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter((5))],
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 18, color: Colors.white),
          decoration: InputDecoration(
              enabledBorder: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0)),
              focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),)
          ),
          validator: (String value){
            int cena = int.tryParse(value);
            //if(value.isEmpty){
            //  return 'Unesite cenu';
            //}
            if(value.isNotEmpty && !RegExp(r"^[0-9]*$").hasMatch(value)) {
              return 'Unesite validnu cenu';
            }
            if(value.isNotEmpty && (cena<0)){
              return 'Cena mora biti pozitivna';
            }
            if(value.isNotEmpty && cena < int.tryParse(_cenaMin)){
              return 'Mora biti veca od minimalne cene';
            }
            return null;
          },
          onSaved: (String value){
            if(value.isNotEmpty) _cenaMax = value;
            else if(value.isEmpty) _cenaMax = "999999";
          },
        )
    );
  }


  void refresh() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshOnPull() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }


  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<AdListModel>(context);
    List listOfAds = [];
    odabraniFilteri odabrani;

    // ovde ucitva profilne slike
    //var listM = Provider.of<UserModel>(context);
    //listM.getPics();

    if(!listModel.isLoading) {
      for (int index = 0; index < listModel.ads.length; index++) {
        if (listModel.ads[index].name
            .toLowerCase()
            .contains(_searchState.toString().toLowerCase()) && (
            (double.parse(listModel.ads[index].price) >=
                double.parse(_cenaMin) &&
                double.parse(listModel.ads[index].price) <=
                    double.parse(_cenaMax) &&
                listModel.ads[index].name
                    .toLowerCase()
                    .contains(_searchState.toString().toLowerCase()))) && (_kategorija=="Izaberi kategoriju" || _kategorija==listModel.ads[index].category)) {
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
      body: listModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: refreshOnPull,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  color: Colors.orange[700],
                  child: SizedBox(
                    height: 150,
                    width: 300,
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
                          width: 280,
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
                        SizedBox(height: 10),
                        Divider(),
                        Container(
                          //child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text("Kategorija:", style: TextStyle(fontSize: 18, color: Colors.white),),
                                _buildKategorija(),

                                SizedBox(height: 20,),
                                Text("Minimalna cena:", style: TextStyle(fontSize: 18, color: Colors.white),),
                                _buildCenaMin(),

                                SizedBox(height: 20,),
                                Text("Maksimalna cena:", style: TextStyle(fontSize: 18, color: Colors.white),),
                                _buildCenaMax(),

                                SizedBox(height: 20),
                                SizedBox(
                                    width: 280,
                                    child : StatefulBuilder(
                                        builder: (context, _setState) =>  Theme(
                                          data: ThemeData(unselectedWidgetColor: Colors.white),
                                          child: CheckboxListTile(
                                            value: _mogucnostRezervacije,
                                            title: Text('Moguća rezervacija', style: TextStyle(fontSize: 18, color: Colors.white),),
                                            onChanged: (newValue){
                                              _setState(() => _mogucnostRezervacije = newValue ? true : false);
                                            },
                                            activeColor: Colors.orangeAccent,
                                            checkColor: Colors.white,
                                          ),
                                        )
                                    )
                                ),
                                SizedBox(height: 40,),
                                SizedBox(
                                  height: 40,
                                  width: 220,
                                  child : ElevatedButton(
                                    child: Text('Primeni filtere', style: TextStyle(color: Colors.white, fontSize: 26)),
                                    onPressed: () async {
                                      debugPrint(_formKey.currentState.toString());
                                      if(!_formKey.currentState.validate()){
                                        sacuvaniFilteri = true;
                                        return;
                                      }
                                      sacuvaniFilteri = true;
                                      _formKey.currentState.save();

                                      setState(() {
                                        _kategorija = _kategorija;
                                        _cenaMin = _cenaMin;
                                        _cenaMax = _cenaMax;
                                        _mogucnostRezervacije = _mogucnostRezervacije;
                                      });

                                      //refresh();
                                      String ispis = "Kategorija: "+_kategorija+" Minimalna cena: "+_cenaMin+" Maksimalna cena: "+_cenaMax+" Moguca rezervacija: "+_getCb();
                                      //debugPrint("Kategorija: "+_kategorija);
                                      //debugPrint("Minimalna cena: "+_cenaMin);
                                      //debugPrint("Maksimalna cena: "+_cenaMax);
                                      //debugPrint("Moguca rezervacija: "+_getCb());


                                      /*
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              content: Text(
                                                ispis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop('/');
                                                    },
                                                    child: Text('OK'))
                                              ],
                                            ));*/
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),

                      ],
                    ),
                  )),
              Expanded(
                child: new DesktoGrid(listModel, listOfAds, myWishList),
                // child: _desktopGrid(listModel, listOfAds),
              )
            ],
          ),
        ),
      ),
      //bottomNavigationBar: Footer(),
    );
  }

  Widget _desktopGrid(AdListModel listModel, List listOfAdds) {

    listOfAdds = listOfAdds.reversed.toList();

    return GridView.builder(
        itemCount: listOfAdds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 5,
            mainAxisExtent: 160),
        itemBuilder: (BuildContext context, int index) {
          // print(listModel.ads[index].name.toLowerCase());

          return kratakPrikazOglasa(
              kategorija: listOfAdds[index].category,
              kratakOpis: listOfAdds[index].description,
              slika: listOfAdds[index].picHash,
              imeProizvoda: listOfAdds[index].name,
              cena: double.parse(listOfAdds[index].price),
              vlasnik: listOfAdds[index].user,
              smeDaKomentarise: false,);

        });
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
