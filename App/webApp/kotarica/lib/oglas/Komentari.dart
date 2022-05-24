import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kotarica/config/config.dart';
import 'package:kotarica/home/HomeStranica.dart';
import 'dart:async';
import 'dart:convert';
import 'package:kotarica/model/Komentar.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'oglas.dart';

String remember_user;
bool remember = false;

class Komentari extends StatelessWidget {
  final String name;
  final String cena;
  final String slika;
  final String opis;
  final String vlasnik;
  final String kategorija;
  final bool smeDaKomentarise;
  Komentari({this.name, this.cena, this.slika, this.opis, this.vlasnik, this.kategorija,this.smeDaKomentarise});

  List<Komentar> list;

  @override
  Widget build(BuildContext context) {
    String url = "${Config.BACKEND_REST}/api/komentar/"+name;
    print(url);

    void Refresh(){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (Oglas(
                name: name,
                price: cena,
                image: slika,
                description: opis,
                owner: vlasnik,
                category: kategorija,
                smeDaKomenatarise: false,
              ))));
    }


    return FutureBuilder(

        future: http.get(Uri.parse("${Config.BACKEND_REST}/api/komentar/"+name),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: "Basic your_api_token_here"
          },),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            getPref();
            String res = snapshot.data.body;
            //debugPrint(res);
            final List parsedList = json.decode(res);
            list = parsedList.map((val) =>  Komentar.fromJson(val)).toList();
            final komentarController = TextEditingController();

            var listM = Provider.of<UserModel>(context);
            // DEO ZA UCITAVANJE SLIKE TRENUTNOG KORISNIKA
            var images = listM.pics;
            String hash1 = "";
            for (var i = 0; i < images.length; i++) {
              if (images[i].username == remember_user)
                hash1 = images[i].picHash;
            }

            // Ovo vraca ako ucita podatke
            return Container(
              child: Row(
                children: [
                  SizedBox(width: 50,),
                  Expanded(
                    child: Container(
                      //color: Colors.blue,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(Icons.comment),
                                SizedBox(width: 5,),
                                Align(alignment: Alignment.centerLeft,child: Text('Komentari',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                                SizedBox(width: 10,),
                                Text(list.length.toString(),style: TextStyle(fontSize: 20),),
                              ],
                            ),
                            Divider(height: 20,color: Colors.black,thickness: 1,endIndent: 400,),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: hash1 != "" ? Image.network("${Config.IAMGE_URL}/$hash1",).image : ExactAssetImage('images/avatar.png'),
                                ),
                                SizedBox(width: 15,),
                                Expanded(child: SizedBox(width: 350,height: 50,child: TextField(controller: komentarController,maxLines: null,decoration: InputDecoration(hintText: 'Napisite komentar...'),))),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Expanded(child: SizedBox(height: 10,)),
                                ElevatedButton(
                                  onPressed: () async {
                                    debugPrint("Sme da komentarise: " + smeDaKomentarise.toString());
                                    debugPrint(komentarController.text);
                                     debugPrint(rememberUser);
                                    if(komentarController.text.isNotEmpty && rememberUser!=null && smeDaKomentarise==true){
                                      remember_user = rememberUser;
                                        debugPrint(komentarController.text);
                                        debugPrint(rememberUser);
                                      //await Komentarisi(komentarController.text);
                                      GetStorageHelper gh = new GetStorageHelper();
                                      print('Authorization' + ':' + 'Basic ' + gh.readUsername() + ":" + gh.readPassword());
                                      print(HttpHeaders.authorizationHeader);
                                      await http.post(Uri.parse("${Config.BACKEND_REST}/api/komentar"),
                                        headers: {
                                          'Content-Type': 'application/json; charset=UTF-8',
                                          'Accept': 'application/json',
                                          HttpHeaders.authorizationHeader: 'Basic ' + base64Encode(utf8.encode(gh.readUsername() + ":" + gh.readPassword()))
                                        },
                                        body: jsonEncode(<String, dynamic>{
                                          "idOglasa": 10,
                                          "nazivOglasa": name,
                                          "korisnik": remember_user,
                                          "tekst": komentarController.text
                                        }),
                                      );
                                      Refresh();
                                    }
                                    else if(rememberUser == null){  // ako nije ulogovan
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: Text(
                                              'Morate biti ulogovani da biste komentarisali',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop('/');
                                                    //Navigator.of(context)
                                                    //    .pushNamed('/login');
                                                  },
                                                  child: Text('OK'))
                                            ],
                                          ));
                                    }
                                    else if(smeDaKomentarise == false){
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: Text(
                                              'Komentarisanje je moguće samo ukoliko ste kupili proizvod',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop('/');
                                                    //Navigator.of(context)
                                                    //    .pushNamed('/login');
                                                  },
                                                  child: Text('OK'))
                                            ],
                                          ));
                                    }
                                  },
                                  child: Text('Objavi', style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                                ),
                                SizedBox(width: 8,),
                                //ElevatedButton(onPressed: (){}, child: Text('Odustani', style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(primary: Colors.grey),),
                              ],
                            ),
                            SizedBox(
                                height: (list.length*100).toDouble(),
                                child: ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    // DEO ZA UCITAVANJE SLIKE
                                    var images = listM.pics;
                                    String hash2 = "";
                                    for (var i = 0; i < images.length; i++) {
                                      if (images[i].username == list[index].korisnik)
                                        hash2 = images[i].picHash;
                                    }
                                    debugPrint("hash2: "+hash2);

                                    return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundImage: hash2 != "" ? Image.network("${Config.IAMGE_URL}/$hash2").image : ExactAssetImage('images/avatar.png'),
                                              ),
                                              SizedBox(width: 15,),
                                              Column(
                                                children: <Widget>[

                                                  Text(list[index].korisnik,style: TextStyle(fontWeight: FontWeight.bold),),
                                                  //Text(DateFormat.yMd().format(vremeObjavljivanja).toString(),style: TextStyle(color: Colors.grey),)
                                                  //Text("04.04.2021.", style: TextStyle(color: Colors.grey),),
                                                ],
                                              ),
                                              Spacer(),
                                              list[index].korisnik == remember_user ?
                                              IconButton(
                                                onPressed: () async {
                                                  GetStorageHelper gh = new GetStorageHelper();
                                                  await http.delete("${Config.BACKEND_REST}/api/komentar/"+list[index].id.toString(),
                                                      headers: <String, String> {
                                                        'Content-Type': 'application/json',
                                                        'Accept': 'application/json',
                                                        HttpHeaders.authorizationHeader: 'Basic ' + base64Encode(utf8.encode(gh.readUsername() + ":" + gh.readPassword()))
                                                      }
                                                  );
                                                  Refresh();
                                                },
                                                icon: Icon(Icons.delete_forever_sharp, color: Colors.red,),
                                              ) : SizedBox(height: 0, width: 0)
                                              //Icon(Icons.delete_forever_sharp, color: Colors.red,),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            list[index].tekst,
                                            textAlign: TextAlign.left,
                                          ),
                                          Divider(
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(width: 50,),
                ],
              ),
            );
          }
          else {
            //return CircularProgressIndicator(backgroundColor: Colors.orange, valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),);
            return Text("Ucitavanje komentara...");
          }
        }
    );
  }
}


getPref() {
  GetStorageHelper gh = new GetStorageHelper();
  var user = gh.readUsername();
  remember_user = user;
  if (user != null) {
    remember = true;
  }
  return user != null ? Container(child:Text('Zdravo,' + user)) : Container(child:Text('Dobrodosli!'));
}