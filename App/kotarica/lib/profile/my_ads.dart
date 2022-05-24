import 'package:flutter/material.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:kotarica/shared/Header.dart';

class MyAds extends StatelessWidget {
  final AdListModel listModel;
  final String rememberUser;

  const MyAds({this.listModel, this.rememberUser});

  @override
  Widget build(BuildContext context) {
    return listModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.white,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: Header(),
              bottomNavigationBar: Footer(),
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
                      child: ListView.builder(

                          //Deo sa oglasima

                          itemCount: listModel.allAds.length,
                          itemBuilder: (BuildContext context, int index) {
                            // print(listModel.ads[index].name.toLowerCase());
                            if (listModel.allAds[index].user == rememberUser) {
                              return kratakPrikazOglasa(
                                kategorija: listModel.allAds[index].category,
                                kratakOpis: listModel.allAds[index].description,
                                slika: listModel.allAds[index].picHash,
                                imeProizvoda: listModel.allAds[index].name,
                                cena:
                                    double.parse(listModel.allAds[index].price),
                                vlasnik: rememberUser,
                                smeDaKomentarise: false,
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                    ),
                  ]),
            ));
  }
}
