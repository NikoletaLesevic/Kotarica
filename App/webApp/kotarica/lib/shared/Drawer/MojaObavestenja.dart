import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/chats.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/model/UserModel.dart';
import 'package:kotarica/model/obavestenje.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MojaObavestenja extends StatelessWidget {
  final VoidCallback goBack;
  String rememberUser;
  MojaObavestenja({this.goBack, this.rememberUser});

  List<obavestenje> ListaObavestenja;
  /* [
    new obavestenje(naslov: 'Nova rezervacija',cena: 200,sadrzaj: "Sadrzaj neki", datum: 'Datum', cijeObavestenje: 1,)
    //new obavestenje(slika: 'jagode.png',cena: 200,kategorija: 'voce i povrce',imeProizvoda: 'Jagode',kratakOpis: 'sveze jagode',cijeObavestenje: 0,),
    //new obavestenje(slika: 'maline.png',cena: 300,kategorija: 'voce i povrce',imeProizvoda: 'Maline',kratakOpis: 'sveze maline',cijeObavestenje: 0,),
    //new obavestenje(slika: 'med.png',cena: 500,kategorija: 'med',imeProizvoda: 'Med',kratakOpis: 'domaci med',cijeObavestenje: 1,),
  ];*/

  @override
  Widget build(BuildContext context) {
    var notifList = Provider.of<NotificationListModel>(context);

    if (notifList.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Notificationn> mojaObavestenja = [];
    if (notifList.notifCount > 0 && !notifList.isLoading)
      for (var i = 0; i < notifList.notifCount; i++) {
        if (notifList.notifications[i].zaKoga == rememberUser &&
            notifList.notifications[i].procitano == false) {
          mojaObavestenja.add(Notificationn(
              id: notifList.notifications[i].id,
              naslov: notifList.notifications[i].naslov,
              sadrzaj: notifList.notifications[i].sadrzaj,
              datum: notifList.notifications[i].datum,
              odKoga: notifList.notifications[i].odKoga,
              zaKoga: notifList.notifications[i].zaKoga,
              procitano: notifList.notifications[i].procitano,
              kupljeno: notifList.notifications[i].kupljeno));
        }
      }

    debugPrint("Broj mojih obavestenja: " + mojaObavestenja.length.toString());

    return Container(
      //color: Colors.greenAccent,
      child: Column(
        children: [
          Container(
              child: Row(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange[700]),
                          onPressed: goBack,
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              Text(
                                'Nazad',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ))))
            ],
          )),

          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            //color: Colors.orange[],
          ),

          //ListView.builder(
          //itemCount: ListaObavestenja.length,
          //itemBuilder:(context,index){ return ListaObavestenja[index];}),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Obaveštenja:  ',
                    style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                  )),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 110,
                child: mojaObavestenja.length > 0
                    ? ListView.builder(
                        itemCount: mojaObavestenja.length,
                        itemBuilder: (context, index) {
                          //return ListaObavestenja[index];
                          return obavestenje(
                            naslov: mojaObavestenja[index].naslov,
                            sadrzaj: mojaObavestenja[index].sadrzaj,
                            datum: mojaObavestenja[index].datum,
                            cijeObavestenje: mojaObavestenja[index].odKoga,
                            idObavestenja: mojaObavestenja[index].id,
                            rememberUser: rememberUser,
                          );
                        },
                      )
                    : Text('Nemate novih obavestenja!',
                        style: TextStyle(
                            backgroundColor: Colors.green[100],
                            fontSize: 22,
                            color: Colors.black)),
              )
            ],
          )
        ],
      ),
    );
  }
}
