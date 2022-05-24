import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/auth/LoginPage.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/shared/responsive_helper.dart';
import 'package:kotarica/wallet/wallet.dart';
import 'package:web3dart/credentials.dart';
import '../home/HomeStranica.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final box = GetStorage();
  String _userName;
  String _password;
  String _firstName;
  String _lastName;
  String _email;
  String _mobile;
  String _address;
  String _privateKey;

  Widget _buildUsername() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite korisničko ime!';
        }
        if (!RegExp(r"^[A-Za-z0-9]*$").hasMatch(value)) {
          return 'Korisničko ime može sadržati isključivo slova i cifre.';
        }
        if (value.length < 7 || value.length > 20) {
          return 'Korisničko ime mora imati najmanje 7, a najviše 20 karaktera.';
        }
        return null;
      },
      onSaved: (String value) {
        _userName = value;
      },
    ));
  }

  Widget _buildPassword() {
    return Container(
        child: TextFormField(
      obscureText: true,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite lozinku!';
        }
        if (!RegExp(r"^[A-Za-z0-9]*$").hasMatch(value)) {
          return 'Lozinka može sadržati isključivo slova i cifre!';
        }
        if (value.length < 7 || value.length > 15) {
          return 'Lozinka mora imati najmanje 7, a najviše 15 karaktera.';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    ));
  }

  Widget _buildFirstName() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite ime!';
        }
        if (!RegExp(r"^[A-Za-z]*$").hasMatch(value)) {
          return 'Pretpostavljamo da Vaše ime sadrži samo slova, molimo Vas budite ozbiljni.';
        }
        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    ));
  }

  Widget _buildLastName() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite prezime!';
        }
        if (!RegExp(r"^[A-Za-z]*$").hasMatch(value)) {
          return 'Pretpostavljamo da Vaše prezime sadrži samo slova, molimo Vas budite ozbiljni.';
        }
        return null;
      },
      onSaved: (String value) {
        _lastName = value;
      },
    ));
  }

  Widget _buildEmail() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite email!';
        }
        if (!value.contains("@")) {
          return 'Molimo Vas, unesite validan email.';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    ));
  }

  Widget _buildPhoneNumber() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_android),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
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
        _mobile = value;
      },
    ));
  }

  Widget _buildAddress() {
    return Container(
        child: TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_pin),
        hintText: "Naziv ulice i broj, grad",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite adresu!';
        }

        return null;
      },
      onSaved: (String value) {
        _address = value;
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<UserModel>(context);
    var notModel = Provider.of<NotificationListModel>(context);
    return Scaffold(
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
        padding: EdgeInsets.only(top: 25, left: 350, right: 350, bottom: 25),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 100, right: 100, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: responsive_signup(listModel, context, notModel),
        ),
      ),
    ));
  }

  Widget responsive_signup(UserModel listModel, BuildContext context,
      NotificationListModel notModel) {
    return Form(
        key: _formKey,
        child: new SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(height: 30),
          Text(
            'Napravi nalog',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          Text(
            'Korisničko ime',
            style: TextStyle(fontSize: 20),
          ),
          _buildUsername(),
          SizedBox(
            height: 30,
          ),
          Text(
            'Lozinka',
            style: TextStyle(fontSize: 20),
          ),
          _buildPassword(),
          SizedBox(
            height: 30,
          ),
          Text(
            'Ime',
            style: TextStyle(fontSize: 20),
          ),
          _buildFirstName(),
          SizedBox(height: 30),
          Text(
            'Prezime',
            style: TextStyle(fontSize: 20),
          ),
          _buildLastName(),
          SizedBox(height: 30),
          Text(
            'Email',
            style: TextStyle(fontSize: 20),
          ),
          _buildEmail(),
          SizedBox(height: 30),
          Text(
            'Mobilni telefon',
            style: TextStyle(fontSize: 20),
          ),
          _buildPhoneNumber(),
          SizedBox(height: 30),
          Text(
            'Adresa',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          _buildAddress(),
          SizedBox(height: 30),
          SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                child: Text('Napravi nalog',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    // ako je validno
                    _formKey.currentState.save();

                    debugPrint(_userName);
                    debugPrint(_lastName);
                    debugPrint(_password);

                    var i = listModel.checkUserZaRegistraciju(_userName);
                    debugPrint(i.toString());
                    if (i.toString() == "POSTOJI") {
                      debugPrint(
                          "Korisnik sa izabranim korisničkim imenom vec postoji");
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(
                                    'Korisnik sa izabranim korisničkim imenom vec postoji!'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'))
                                ],
                              ));
                    } else {
                      Alert(
                        context: context,
                        title:
                            "Unesite privatni ključ Vašeg Ethereum naloga,\nukoliko ne unesete, opcija plaćanja kriptovalutom Vam neće biti dostupna.",
                        content: Form(
                          key: _formKey2,
                          child: TextFormField(
                            validator: (value) {
                              return value.isNotEmpty ? null : "Prazno polje";
                            },
                            onSaved: (String value) {
                              _privateKey = value;
                            },
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                        ),
                        buttons: [
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              if (_formKey2.currentState.validate()) {
                                _formKey2.currentState.save();

                                //listModel.addPrivateKey(_privateKey);
                                showAlertDialog(context);
                                debugPrint("Dodat private key" + _privateKey);
                                //listModel.addPrivateKey(_privateKey);
                                showAlertDialog(context);
                                debugPrint("Dodat private key" + _privateKey);

                                await listModel.addUser(
                                    _userName,
                                    _password,
                                    _firstName,
                                    _lastName,
                                    _email,
                                    _mobile,
                                    _address);

                                await http.post(
                                  Uri.parse("${Config.BACKEND_REST}/api/user"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    HttpHeaders.authorizationHeader:
                                        "Basic your_api_token_here"
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    "username": _userName,
                                    "password":
                                        base64Encode(utf8.encode(_password)),
                                  }),
                                );
                                GetStorageHelper gh = new GetStorageHelper();
                                gh.addUsername(_userName);
                                gh.addPassword(
                                    base64Encode(utf8.encode(_password)));
                                var pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('userName', _userName);

                                // listModel.addUser(
                                //     _userName,
                                //     _password,
                                //     _firstName,
                                //     _lastName,
                                //     _email,
                                //     _mobile,
                                //     _address);
                                // var pref =
                                //     await SharedPreferences.getInstance();
                                // pref.setString('userName', _userName);

                                UsersWallet usersWallet =
                                    new UsersWallet(_userName);
                                //username = _userName;
                                await usersWallet.writeWallet(_privateKey);
                                EthereumAddress public =
                                    await usersWallet.getAdress();
                                await notModel.createWallet(
                                    _userName, true, public.toString());
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomeStranica()));
                              }
                            },
                            color: Colors.orange[400],
                          ),
                          DialogButton(
                            child: Text(
                              "Nastavi bez ključa",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              showAlertDialog(context);
                             await listModel.addUser(
                                  _userName,
                                  _password,
                                  _firstName,
                                  _lastName,
                                  _email,
                                  _mobile,
                                  _address);

                              await http.post(
                                Uri.parse("${Config.BACKEND_REST}/api/user"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader:
                                      "Basic your_api_token_here"
                                },
                                body: jsonEncode(<String, dynamic>{
                                  "username": _userName,
                                  "password":
                                      base64Encode(utf8.encode(_password)),
                                }),
                              );
                              GetStorageHelper gh = new GetStorageHelper();
                              gh.addUsername(_userName);
                              gh.addPassword(
                                  base64Encode(utf8.encode(_password)));

                              var pref = await SharedPreferences.getInstance();
                              pref.setString('userName', _userName);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeStranica()));
                            },
                            color: Colors.orange[400],
                          ),
                          DialogButton(
                              child: Text(
                                'Šta je Ethereum nalog?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Ethereum nalog predstavlja nalog na globalnoj Ethereum mreži, koji omogućava izvršavanje transakcija.\nSvi podaci na ovoj mreži su enkriptovani i bezbedno se čuvaju, a svaka transakcija je vidljiva svim korisnicima.\nUkoliko nemate kreiran nalog, a želite da kupujete kriptovalutom, preporučujemo sajt myetherwallet.com',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'))
                                          ],
                                        ));
                              },
                              color: Colors.orange[400])
                        ],
                      ).show();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)))),
              )),
          SizedBox(height: 30),
          SizedBox(
            height: 50,
            width: 350,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(MaterialPageRoute(builder: (context) => LogInPage()));
              },
              child: Text(
                "Vrati se nazad na prijavu",
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            ),
          ),

          //BottomAppBarHome(),
        ])));
  }
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.orange,
    title: Center(
      child: Text(
        "Kreiranje naloga...",
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
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
