import 'package:flutter/material.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/shared/Header.dart';

class MyAds extends StatelessWidget {
  final AdListModel listModel;
  final String rememberUser;

  const MyAds({this.listModel, this.rememberUser});

  @override
  Widget build(BuildContext context) {

      List<Ad> mojiOglasi = [];
      for(var i=0;i<listModel.allAds.length; i++)
      {
        if(listModel.allAds[i].user == rememberUser)
        mojiOglasi.add(new Ad(category: listModel.allAds[i].category,
                              contact: listModel.allAds[i].contact,
                              name: listModel.allAds[i].name,
                              description: listModel.allAds[i].description,
                              picHash: listModel.allAds[i].picHash,
                              price: listModel.allAds[i].price,
                              user: listModel.allAds[i].user));
      }

    return listModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.white,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: Header(),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        "Moji Oglasi",
                        style: TextStyle(
                            fontSize: 28.0,
                            color: Color(0xff480355),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          padding: EdgeInsets.all(15),
                          itemCount: mojiOglasi.length,//listModel.allAds.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 160),
                          itemBuilder: (BuildContext context, int index) {
                            // print(listModel.ads[index].name.toLowerCase());
                           // if (listModel.allAds[index].user == rememberUser) {
                              return kratakPrikazOglasa(
                                kategorija: mojiOglasi[index].category, //listModel.allAds[index].category,
                                kratakOpis: mojiOglasi[index].description, //listModel.allAds[index].description,
                                slika: mojiOglasi[index].picHash, //listModel.allAds[index].picHash,
                                imeProizvoda: mojiOglasi[index].name, //listModel.allAds[index].name,
                                cena:
                                    double.parse(mojiOglasi[index].price),
                                vlasnik: rememberUser,
                                smeDaKomentarise: false,
                              );
                            
                            }
                          ),
                    ),
                  ]),
            ));
  }
}
