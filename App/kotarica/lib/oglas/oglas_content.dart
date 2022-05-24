import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kotarica/chat/chat.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/oglas/Kupovina.dart';
import 'package:kotarica/shared/carousel.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/oglas/Komentari.dart';

String rememberUser;
bool zapamti = false;

class OglasContent extends StatefulWidget {
  final String name;
  final String price;
  final String owner;
  final String image;
  final String description;
  final String category;
  final bool smeDaKomentarise;

  bool vidljivTel = false;
  bool vidljivoDugme = true;

  OglasContent(
      {this.name,
      this.price,
      this.owner,
      this.image,
      this.description,
      this.category,
      this.smeDaKomentarise});

  @override
  oglasContentState createState() => oglasContentState();
}

class oglasContentState extends State<OglasContent> {



  Future<List<String>> ucitajSlike(var listModel) async {
    // vraca listu hasheva slika
    //await listModel.getPics();
    List<Slika> sveSlike = listModel.slike;
    List<String> mojiHasheviSlika = [];
    if (sveSlike != null) {
      for (int i = 0; i < sveSlike.length; i++) {
        if (sveSlike[i].adName == widget.name && sveSlike[i].adOwner == widget.owner) {
          mojiHasheviSlika.add(sveSlike[i].hash);
        }
      }
    }
    return mojiHasheviSlika;
  }

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<AdListModel>(context);
    var userModel = Provider.of<UserModel>(context);

    if(userModel.isLoading || listModel.isLoading)
    {
      return Center(child: CircularProgressIndicator());
    }

    List<Slika> sveSlike = listModel.slike;
    List<String> mojiHasheviSlika = [];
    if (sveSlike != null) {
      for (int i = 0; i < sveSlike.length; i++) {
        if (sveSlike[i].adName == widget.name && sveSlike[i].adOwner == widget.owner) {
          mojiHasheviSlika.add(sveSlike[i].hash);
        }
      }
    }

    debugPrint(widget.name + "  " + widget.owner);
    var ocena;
    ocena = listModel.izracunajProsecnuOcenu(widget.name, widget.owner);
    debugPrint("Prosecna ocena: " + ocena.toString());
    if (ocena == null) ocena = 0;

    var brojOcena;
    for (var i = 0; i < listModel.oceneCount; i++) {
      if (listModel.ocene[i].adName == widget.name &&
          listModel.ocene[i].adOwner == widget.owner)
        brojOcena = listModel.ocene[i].brojOcena;
    }
    var brojPreporuka = 0.0;
    for (var i = 0; i < listModel.allAds.length; i++) {
      if (listModel.allAds[i].category == widget.category &&
          listModel.allAds[i].picHash != widget.image)
        brojPreporuka = brojPreporuka + 1;
    }

    var contactTel = "";
    for(var i=0; i<userModel.userCount; i++) {
      if(userModel.users[i].userName == widget.owner) {
        contactTel = userModel.users[i].mobile;
      }
    }

    debugPrint("Broj ocena: " + brojOcena.toString());

    getPref();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: SizedBox(
              height: 300,
                child: Carousel(
                  image: widget.image,
                  images: mojiHasheviSlika,
                ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              )),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.price,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              Text("din.",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RatingBar.builder(
                  unratedColor: Colors.orange[100],
                  wrapAlignment: WrapAlignment.center,
                  initialRating: ocena.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 35.0,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: 2.0, vertical: 7),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber[600]),
                  onRatingUpdate: (rating) {
                    //rating = double.parse(ocena);
                    debugPrint("Rating" + rating.toString());
                  },
                ),
              ]),
              SizedBox(
                width: 5,
              ),
              Text(
                brojOcena == null
                    ? 'Nije ocenjivano'
                    : 'Broj ocena: ' + brojOcena.toString(),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
            height: 150,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              widget.description,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  "Prodavac:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.owner, style: TextStyle(fontSize: 18))
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  "Kontakt telefon:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              widget.vidljivTel==false ? ElevatedButton(onPressed: () { 
                setState(() {
                             widget.vidljivTel = true; widget.vidljivoDugme = false;     
                                });}
                 , child: Text('Kliknite za telefon', style: TextStyle(fontSize: 18,)),style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent))
              : Text(contactTel,style: TextStyle(fontSize: 18),)
              //Text(contactTel, style: TextStyle(fontSize: 18))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Kupovina(
                            name: widget.name,
                            price: widget.price,
                            rememberUser: rememberUser,
                            owner: widget.owner)),
                  );
                },
                child: Text(
                  "Kupi proizvod",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: EdgeInsets.all(13.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
              ElevatedButton(
                onPressed: () {
                  if (rememberUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Chat(
                          loginUser: rememberUser,
                          chatUser: widget.owner,
                          // loginUser: rem,
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Text(
                                'Morate biti ulogovani da biste poslali poruku',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop('/');
                                      Navigator.of(context).pushNamed('/login');
                                    },
                                    child: Text('OK'))
                              ],
                            ));
                  }
                },
                child: Text(
                  "Pošalji poruku",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[200],
                    padding: EdgeInsets.all(13.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          Komentari(name: widget.name, slika: widget.image, vlasnik: widget.owner, opis: widget.description, cena: widget.price, kategorija: widget.category,smeDaKomentarise: widget.smeDaKomentarise,),
          SizedBox(height: 10),
          //rememberUser == null ? Text("USER") : Text(rememberUser),
          Text(
            "  Preporučeni proizvodi:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          brojPreporuka == 0
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text("Nema preporučenih oglasa"),
                )
              : Container(
                  //height: brojPreporuka * 160.0,
                  height: 310,
                  width: brojPreporuka * 100,
                  child: ListView.builder(
                      itemCount: listModel.allAds.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        //debugPrint(this.category);
                        //debugPrint(listModel.allAds[index].category);
                        if (listModel.allAds[index].category == widget.category &&
                            listModel.allAds[index].picHash != widget.image) {
                          return Row(
                            children: <Widget>[
                              kratakPrikazOglasa(
                              kategorija: listModel.allAds[index].category,
                                kratakOpis: listModel.allAds[index].description,
                                slika: listModel.allAds[index].picHash,
                                imeProizvoda: listModel.allAds[index].name,
                                cena: double.parse(listModel.allAds[index].price),
                                vlasnik: widget.owner,
                                smeDaKomentarise: false,
                              ),
                              SizedBox(width: 10,),
                            ],
                          );
                        } else {
                          return SizedBox(
                            width: 0.0000000001,
                          );
                        }
                      }),
                ),
          //SizedBox(height: 10,),
        ],
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
