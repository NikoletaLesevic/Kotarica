import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class User {
  
  int id;
  String email;
  String lozinka;
  String ime;
  String prezime;

  User(email, lozinka, ime,prezime) {
    this.email = email;
    this.lozinka = lozinka;
    this.ime = ime;
    this.prezime = prezime;
  }

  User.id(id, email, lozinka, ime,prezime) {
    this.id = id;
    this.email = email;
    this.lozinka = lozinka;
    this.ime = ime;
    this.prezime = prezime;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null)
      map['Id'] = id;
    
    map['Email'] = email;
    map['Password'] = lozinka;
    map['ime'] = ime;
    map['prezime'] = prezime;
    return map;
  }

  User.fromObject(dynamic o) {
    this.id = o['Ed'];
    this.email = o['Email'];
    this.lozinka = o['Password'];
    this.ime = o['ime'];
    this.prezime = o['prezime'];
  }

  static Map<String,String> header = {
    'Content-type': ' application/json',
    'Accept' : 'application/json'
  };

  static Future<String> proveriKorisnika(String email, String lozinka) async
  {
    String url = 'http://127.0.0.1:54317/api/Users/login';
    var data = Map();
    data['Email'] = email;
    data['Password'] = lozinka;
    
    var jsonBody = convert.jsonEncode(data);
    
    var res = await http.post(url, headers: header, body: jsonBody);
    String data2 = res.body.toString();
    print(data2);
    return data2;
  }

  static Future<bool> registrujKorisnika(User u) async
  {
    String url = 'http://127.0.0.1:54317/api/Users/';
    var userMap = u.toMap();
    var jsonBody = convert.jsonEncode(userMap);
    print(jsonBody);
    if(proveriKorisnika(u.email, u.lozinka).toString() == "true")
      return false;
    else
    {
      var res = await http.post(url,headers: header,body: jsonBody);
      return true;
    }

  } 


}