import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:app/model/korisnik.dart' as korisnik;

import 'home_page.dart';
import 'signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/home_page': (BuildContext context) => new Home()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String email='';
  String password='';

  bool ulogujSe(email, password) {
    //Response response =await get('htpp://127.0.0.1:57323/api/Users/$email&$password');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 80.0, 0.0, 0.0),
                  child: Text(
                    'Hello there',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      
                     
                      color: Colors.blue
                    ),
                  ),
                ),
             
               
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (val) async {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(
                  
                    labelText: "Email",
                    
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (val) async {
                    setState(() => password = val);
                  },
                  decoration: InputDecoration(
                    
                  
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                      
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 50.0),
                Container(
                  height: 40.0,
                  child: Material(
                    //borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.blue,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () async {
                        print("EMAIL:" + email + "; LOZINKA:" + password);

                        if (email.isEmpty || password.isEmpty) {
                          print("IMEJL I LOZINKA SU PRAZNI");
                        } else {

                        var pass1 = utf8.encode(password);
                         var  pass2 = sha1.convert(pass1);
                          print("sdasdasdasd" + pass2.toString());
                          var rez = await korisnik.User.proveriKorisnika(
                              email, pass2.toString());

                          if (rez == "true") {
                            Navigator.of(context).pushNamed('/home_page');
                          } else {
                            //pogresno korisnicko ime ili lozinka
                            print("Pogresno korisnicko ime ili lozinka");
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "or",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey
                ),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  email = null;
                  password = null;
                  //ide na stranicu za registraciju
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text(
                  "create an account",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
