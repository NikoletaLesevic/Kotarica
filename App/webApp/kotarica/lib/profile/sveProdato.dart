import 'package:flutter/material.dart';
import 'package:kotarica/home/KratakPrikazOglasa.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/profile/prikazProdaje.dart';
import 'package:kotarica/shared/Header.dart';

class sveProdato extends StatelessWidget {
  final NotificationListModel listModel;
  final String rememberUser;

  const sveProdato({this.listModel, this.rememberUser});

  @override
  Widget build(BuildContext context) {
    List<KupovinaLogika> mojeProdato = [];
    for (var i = 0; i < listModel.kupovineCount; i++) {
      if (listModel.kupovine[i].adOwner == rememberUser)
        mojeProdato.add(KupovinaLogika(
            id: listModel.kupovine[i].id,
            adName: listModel.kupovine[i].adName,
            adOwner: listModel.kupovine[i].adOwner,
            usernameKupac: listModel.kupovine[i].usernameKupac,
            kupljeno: listModel.kupovine[i].kupljeno,
            datum: listModel.kupovine[i].datum));
    }

    return Container(
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
                      "Moji prodati proizvodi",
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xff480355),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      child: mojeProdato.length == 0
                          ? Text('  Niste prodali nijedan proizvod!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                          : GridView.builder(
                              padding: EdgeInsets.all(15),
                              itemCount: mojeProdato.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 5,
                                      mainAxisExtent: 160),
                              itemBuilder: (BuildContext context, int index) {
                                // print(listModel.ads[index].name.toLowerCase());
                                return prikazProdaje(
                                  id: mojeProdato[index].id,
                                  datum: mojeProdato[index].datum,
                                  kupac: mojeProdato[index].usernameKupac,
                                  nazivProizvoda: mojeProdato[index].adName,
                                  vlasnik: mojeProdato[index].adOwner,
                                  vrstaKupovine: mojeProdato[index].kupljeno,
                                );
                              }))
                ])));
  }
}
