import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/shared/Drawer/main_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:kotarica/storage/getstorage.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:permission_handler/permission_handler.dart';

String rememberUser;
bool zapamti = false;
// bool isLoading = false;

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _checked = false;
  var maxduzina = 0;

  List<String> names = [
    'nemaslike',
    'nemaslike',
    'nemaslike',
    'nemaslike',
    'nemaslike'
  ];
  List<Uint8List> datas = new List(5);

  String name = '';
  String error;
  Uint8List data;

  pickImagePrethodni() {
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..multiple = true
      //..maxLength = 5 -> ne radi
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      debugPrint("Broj slika: " + input.files.length.toString());
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

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  pickImage() {
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..multiple = true
      //..maxLength = 5 -> ne radi
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      debugPrint("Broj slika: " + input.files.length.toString());
      maxduzina = input.files.length > 5 ? 5 : input.files.length;
      //final reader = FileReader();
      for (int i = 0; i < maxduzina; i++) {
        var trenutnireader = FileReader();
        trenutnireader.readAsDataUrl(input.files[i]);
        trenutnireader.onError.listen((err) => setState(() {
              error = err.toString();
            }));
        trenutnireader.onLoad.first.then((res) async {
          final encoded = trenutnireader.result as String;
          // remove data:image/*;base64 preambule
          final stripped =
              encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

          setState(() {
            names[i] = input.files[i].name;
            datas[i] = base64.decode(stripped);
            error = null;
            debugPrint(names[i]);
            //debugPrint("names: "+names[0]+", "+names[1]+", "+names[2]+", "+names[3]+", "+names[4] + ".");
          });
        });
      } //KRAJ FOR PETLJE
    });

    input.click();
  }

  Future<String> uploadImage(filename, list, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //request.files.add(await http.MultipartFile.fromPath('image', filename));
    print("SA:JEM ZAHTEV");
    request.files.add(
        await http.MultipartFile.fromBytes('image', list, filename: filename));
    print("DOBIO SAM ODGOVOR");
    http.Response response =
        await http.Response.fromStream(await request.send());

    print("Result: ${response.statusCode}");

    return response.body;
    // var res = await request.send();
    // print(res.toString());
    // print(res.)
    // return res.reasonPhrase;
  }

  String _kategorija = 'Meso i mesne preradjevine';
  String _naziv;
  String _cena;
  String _grad;
  String _adresa;
  String _opis;
  String _brtelefona;

  // Funkcija koja ispisuje inpute u alert box-u
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Primljene vrednosti"),
      content: Text("Naziv proizvoda: " +
          _naziv +
          "\nCena: " +
          _cena +
          "\nGrad: " +
          _grad +
          "\nAdresa: " +
          _adresa +
          "\nOpis: " +
          _opis +
          "\nMoguca rezervacija: " +
          _getCb()),
      actions: [
        okButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String _getCb() {
    if (_checked == true) {
      return 'Da';
    } else {
      return 'Ne';
    }
  }

  Widget _buildKategorija() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: DropdownButtonFormField<String>(
          value: _kategorija,
          hint: Text('Izaberi kategoriju'),
          dropdownColor: Colors.orange,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          items: <String>[
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
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              _kategorija = value;
            });
          },
        ));
  }

  Widget _buildNaziv() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Unesite naziv';
            }
            return null;
          },
          onSaved: (String value) {
            _naziv = value;
          },
        ));
  }

  Widget _buildCena() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ], // moguce je uneti samo brojeve
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            suffixIcon: Padding(      //suffixIcon, this way it don't disapear when the TextField is unfocused
              padding: EdgeInsets.all(20), //padding to put closer to the line
              child: Text(
                'RSD',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          validator: (String value) {
            int cena = int.tryParse(value);

            if (value.isEmpty) {
              return 'Unesite cenu';
            }

            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
              return 'Unesite validnu cenu';
            }

            if (cena <= 0 || cena == null) {
              return 'Cena mora biti pozitivna';
            }

            return null;
          },
          onSaved: (String value) {
            _cena = value;
          },
        ));
  }

  Widget _buildGrad() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Unesite grad';
            }
            return null;
          },
          onSaved: (String value) {
            _grad = value;
          },
        ));
  }

  Widget _buildBrTelefona() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          //initialValue: ,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ], // moguce je uneti samo brojeve
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          validator: (String value) {
            if (value.isEmpty || value.length < 9) {
              return 'Unesite validan broj telefona!';
            }
            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
              return 'Brojevi telefona sadrže isključivo cifre!';
            }

            return null;
          },
          onSaved: (String value) {
            _brtelefona = value;
          },
        ));
  }

  Widget _buildAdresa() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Unesite adresu';
            }
            return null;
          },
          onSaved: (String value) {
            _adresa = value;
          },
        ));
  }

  Widget _buildOpis() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          maxLines: 4,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Unesite opis';
            }
            return null;
          },
          onSaved: (String value) {
            _opis = value;
          },
        ));
  }

  Widget _prikaziDodateSlike() {
    if(names.length == 0){
      return Text("Nisu dodate slike");
    }
    else{
      int j=0;
      String ispis="";
      for(int i=0; i<names.length; i++){
        if(names[i] != "nemaslike"){
          if(j==0){ ispis += "Dodate slike: "; }
          ispis += names[i];
          if(i != names.length-1) ispis += ", ";
          j++;
        }
      }
      if (ispis != null && ispis.length > 0) {
        ispis = ispis.substring(0, ispis.length - 2);
      }
      return Text(ispis);
    }
  }

  Widget build(BuildContext context) {
    var listModel = Provider.of<AdListModel>(context);
    getPref();

    return Scaffold(
        appBar: Header(),
        endDrawer: MainDrawer(),
        body: SingleChildScrollView(
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
              ),
              child: Center(
                  child: Form(
                      key: _formKey,
                      child: new SingleChildScrollView(
                          child: Column(children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          //color: Colors.red,
                          decoration: new BoxDecoration(
                            color: Colors
                                .white, //new Color.fromRGBO(255, 0, 0, 0.0),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                              bottomLeft: const Radius.circular(40.0),
                              bottomRight: const Radius.circular(40.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Postavi oglas',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.grey[900]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Kategorija',
                                style: TextStyle(fontSize: 20),
                              ),
                              _buildKategorija(),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Naziv proizvoda',
                                style: TextStyle(fontSize: 20),
                              ),
                              _buildNaziv(),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Cena',
                                style: TextStyle(fontSize: 20),
                              ),
                              _buildCena(),
                              SizedBox(height: 40),
                              //Text('Grad', style: TextStyle(fontSize: 20),),
                              //_buildGrad(),
                              //SizedBox(height: 30),
                              //Text('Adresa', style: TextStyle(fontSize: 20),),
                              //_buildAdresa(),
                              //SizedBox(height: 30),
                              Text(
                                'Broj telefona',
                                style: TextStyle(fontSize: 20),
                              ),
                              _buildBrTelefona(),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Opis',
                                style: TextStyle(fontSize: 20),
                              ),
                              _buildOpis(),
                              SizedBox(height: 40),
                              Text(
                                'Dodaj slike',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                //width: 270,
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueAccent),
                                  onPressed: pickImage,
                                  child: Text(
                                    'Browse',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              names.length != 0 ? _prikaziDodateSlike() : SizedBox(height: 0),
                              SizedBox(height: 40),
                              SizedBox(
                                  width: 270,
                                  child: StatefulBuilder(
                                      builder: (context, _setState) =>
                                          CheckboxListTile(
                                            value: _checked,
                                            title: Text(
                                              'Moguća rezervacija',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            onChanged: (newValue) {
                                              _setState(() => _checked =
                                                  newValue ? true : false);
                                            },
                                            activeColor: Colors.white60,
                                            checkColor: Colors.orange,
                                          ))),
                              SizedBox(height: 60),
                              SizedBox(
                                height: 50,
                                //width: 220,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: ElevatedButton(
                                  child: Text('Postavi oglas',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30)),
                                  onPressed: () async {
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                    // ovo je ako je validno
                                    _formKey.currentState.save();

                                    // prikazi Alert Box
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: Colors.orange,
                                          title: Center(
                                            child: Text(
                                              "Postavljanje oglasa...",
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
                                        ));

                                    // sacuvaj slike i dodaj oglas
                                    //List<int> resList = List(maxduzina);
                                    for (int i = 0; i < maxduzina; i++) {
                                      List<int> list = datas[i].cast();
                                      var res = await uploadImage(
                                          names[i], list, Config.BACKEND_IMAGE);
                                      print("Res je");
                                      print(res);
                                      if (zapamti) {
                                        if (i == 0) {
                                          // SAMO PRVI PUT SE KREIRA OGLAS
                                          await listModel.addAd(
                                              _naziv,
                                              _kategorija,
                                              _opis,
                                              _cena,
                                              _brtelefona,
                                              rememberUser,
                                              res.toString());
                                        }
                                        await listModel.addPic(_naziv, rememberUser,
                                            res.toString());
                                      }
                                    }

                                    //print(_kategorija);
                                    //print(_naziv);
                                    //print(_cena);
                                    //print(_adresa);
                                    //print(_opis);
                                    // var probni = "Qmd8JMqyFzoR6g6ALALAhWufyu57iJSjd5XsKNgYs9o2Di";
                                    //if(zapamti) {
                                    //  listModel.addAd(_naziv, _kategorija, _opis, _cena, "06743821", rememberUser,res.toString());
                                    //}

                                    // showAlertDialog(context);
                                    if (zapamti) {
                                      Navigator.pushNamed(context, "/");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 60),
                            ],
                          ),
                        ),

                        //Text(zapamti ? rememberUser : "@korisnickoime")
                        //BottomAppBarHome(),
                      ]))))),
        ));
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
