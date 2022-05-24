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

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';


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
  var _checked = true;

  File file;
  void pickImage() async {
    PickedFile pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    //file = File(pickedFile.path)
    if (pickedFile != null) {
      file = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  Future<String> uploadImageStari(filename, url) async {
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

  String _kategorija = 'Meso i mesne preradjevine';
  String _naziv;
  String _cena;
  String _grad;
  String _adresa;
  String _opis;
  String _brtelefona;

  String _getCb() {
    if (_checked == true) {
      return 'Da';
    } else {
      return 'Ne';
    }
  }


  // novo
  Future<String> uploadImage(var filename, url) async {
    //print(filename.path);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filename.path));
    //var res = await request.send();

    http.Response response =
    await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");

    //return response.body.hashCode;
    return response.body;

    //return res.stream.bytesToString();
    //return res.reasonPhrase;
  }

  List<File> files = List();
  List<Asset> images = List<Asset>();
  List<String> stringslike = ["", "", "", "", ""];

  void pickImages() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,

      );
    } on Exception catch (e) {
      error = e.toString();
    }

    setState(() {
      images = resultList;
      debugPrint("images length: "+ images.length.toString());
      if(images.length > 0)
        debugPrint("name : "+images[0].name);
    });
  }



  Widget _buildKategorija() {
    return Container(
        padding: EdgeInsets.all(10),
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
        padding: EdgeInsets.all(10),
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
        padding: EdgeInsets.all(10),
        child: TextFormField(
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
        padding: EdgeInsets.all(10),
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
        padding: EdgeInsets.all(10),
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
        child: TextFormField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
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
        padding: EdgeInsets.all(10),
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
    if(images.length == 0){
      return Text("Nisu dodate slike");
    }
    else{
      int j=0;
      String ispis="Dodate slike: ";
      for(int i=0; i<images.length; i++){
        ispis += images[i].name;
        if(i == images.length-1) ispis += "";
        else ispis += ",\n";
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
        bottomNavigationBar: Footer(),
        body: SingleChildScrollView(
            child: Center(
                child: Form(
                    key: _formKey,
                    child: new SingleChildScrollView(
                        child: Column(children: <Widget>[
                          SizedBox(height: 40),
                          Text(
                            'Postavi oglas',
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Color(0xff480355),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Kategorija',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          _buildKategorija(),
                          SizedBox(height: 20,),
                          Text(
                            'Naziv proizvoda',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          _buildNaziv(),
                          SizedBox(height: 20,),
                          Text(
                            'Cena',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          _buildCena(),
                          SizedBox(height: 20),
                          Text('Broj telefona', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          _buildBrTelefona(),
                          SizedBox(height: 20,),
                          Text('Opis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          _buildOpis(),
                          SizedBox(height: 20),
                          SizedBox(
                              width: 300,
                              child: StatefulBuilder(
                                  builder: (context, _setState) => CheckboxListTile(
                                    value: _checked,
                                    title: Text(
                                      'Moguća rezervacija',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onChanged: (newValue) {
                                      _setState(() =>
                                      _checked = newValue ? true : false);
                                    },
                                    activeColor: Colors.white60,
                                    checkColor: Colors.orange,
                                  ))),
                          SizedBox(height: 20),
                          Text('Dodaj slike', style: TextStyle(fontSize: 20,),),
                          SizedBox(
                            height: 40,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue[200],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)))),
                              onPressed: pickImages,
                              child: Text('Browse', style: TextStyle(fontSize: 20, color: Colors.white),),
                            ),
                          ),
                          SizedBox(height: 10,),
                          _prikaziDodateSlike(),
                          SizedBox(height: 40),
                          SizedBox(
                            height: 60,
                            width: 330,
                            child: ElevatedButton(
                              child: Text('Postavi oglas',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 30)),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[400],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)))),
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


                                for(int i=0; i<images.length; i++){
                                  var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
                                  File fajl = File(path);
                                  var res = await uploadImageStari(path, Config.BACKEND_IMAGE);
                                  //debugPrint("dodata slika : "+images[i].identifier+ " !");

                                  if(zapamti){
                                    if(i==0){  // Kreira se oglas sa prvom slikom
                                      await listModel.addAd(_naziv, _kategorija, _opis, _cena, _brtelefona, rememberUser,res.toString());
                                      debugPrint("dodat oglas : "+_naziv+", hash: "+res.toString());
                                    }
                                    // dodaju se slike oglasa
                                    await listModel.addPic(_naziv, rememberUser, res.toString());
                                    debugPrint("dodata slika");
                                  }
                                }

                                // showAlertDialog(context);
                                //await listModel.getAllAds();
                                debugPrint("broj oglasa: "+listModel.adCount.toString());
                                if (zapamti) {
                                  Navigator.pushNamed(context, "/");
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 60),

                          //Text(zapamti ? rememberUser : "@korisnickoime")
                          //BottomAppBarHome(),
                        ]))))));
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
