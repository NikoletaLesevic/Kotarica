//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kotarica/chat/chats.dart';
import 'package:kotarica/config/config.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/wallet/wallet.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';


class obavestenje extends StatefulWidget {

  final String naslov;
  final String sadrzaj;
 // final String slika;
  //final double cena;
  final String datum;
  final BigInt idObavestenja;

  final String cijeObavestenje;//za koga //0 je ako je prodavac, 1 ako je kupac
  final String rememberUser; //od koga
  const obavestenje(
      {Key key,
        this.naslov,
        this.sadrzaj,
        this.datum,
         this.cijeObavestenje,
         this.rememberUser,
         this.idObavestenja})
      : super(key: key);

  @override
  _obavestenjeState createState() => _obavestenjeState();
}

class _obavestenjeState extends State<obavestenje> {

  bool odbijeno = false;

  @override
  Widget build(BuildContext context) {


    var notifList = Provider.of<NotificationListModel>(context);
    var adList = Provider.of<AdListModel>(context);
    

    var kupovina;
    if(widget.sadrzaj.contains('kupovina'))
    kupovina = 'kupovina';
    else
    kupovina = 'rezervacija';

    BigInt oznaka;
    for(var i=0;i<notifList.notifCount;i++)
    {
      if(notifList.notifications[i].id == widget.idObavestenja)
      oznaka = notifList.notifications[i].kupljeno;
    }



    int povratno=0;
    String kupca;
    if(widget.naslov.contains("Odbijena") || widget.naslov.contains("Odobrena")){
    povratno=1;
    kupca = "Kupca"; }
    else
    {
      kupca = "Prodavca";
    }

    String poruka = "Poruka: ";
    var cena;

    TextEditingController porukaCtrl = TextEditingController();

        if(povratno == 0)
          ///PRODAVAC
          return Container(
        child: Column(
            children: <Widget>[

              Container(
                color: (oznaka.toInt() == 0 ? Colors.green[100] : Colors.orange[100]),  ///OVDE SE BOJI DA BI SE RAZLIKOVALA OBAVESTENJA
                child: Row(
                  children: [
                      //SizedBox(width: 5,),
                      //Image.asset('images/$slika',width: 100,height: 100,),
                      Expanded(child: SizedBox(width: 10,)),
                      Column(

                        children: <Widget>[

                            SizedBox(height: 10,),
                            Text("" + this.widget.sadrzaj.split('\n')[0],textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold), ),

                            SizedBox(height: 2,),
                            Row(children: [
                                Text("" + this.widget.sadrzaj.split('\n')[1].split(' ')[0],),
                               Text(" " + this.widget.sadrzaj.split('\n')[1].split(' ')[1],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ],),
                            Row(children: [
                                Text("" + this.widget.sadrzaj.split('\n')[2].split(':')[0] + ":"),
                                Text(" " + this.widget.sadrzaj.split('\n')[2].split(':')[1],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold), ),
                            ],),
                            Text(" " + this.widget.naslov, textAlign: TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                            SizedBox(height: 10,),
                           Text(" *" + this.widget.sadrzaj.split('\n')[3] + "* ", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, )),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Container(
                                  //color: Colors.green,
                                  //margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent,),borderRadius: BorderRadius.all(Radius.circular(20))),

                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("" + this.widget.sadrzaj.split('\n')[4].split(':')[0] + ": ", style: TextStyle(fontStyle: FontStyle.italic),),
                                          Text("" + this.widget.sadrzaj.split('\n')[4].split(":")[1]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("" + this.widget.sadrzaj.split('\n')[5].split(": ")[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                          Text("" + this.widget.sadrzaj.split('\n')[5].split(": ")[1]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("" + this.widget.sadrzaj.split('\n')[6].split(':')[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                          Text("" + this.widget.sadrzaj.split('\n')[6].split(':')[1]),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text("" + this.widget.sadrzaj.split('\n')[7].split(':')[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                          Text("" + this.widget.sadrzaj.split('\n')[7].split(':')[1]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(" " + this.widget.datum, textAlign: TextAlign.center,),
                            SizedBox(height: 10,),
                            Text("Opcije: "),
                            SizedBox(height: 10,),
                            //Text("Poruka za $kupca",textAlign: TextAlign.left,),


                            Row(
                      children: [
                        Visibility(
                            visible: true,
                            child: SizedBox(width: 40,height:40,child: ElevatedButton(onPressed: () async {

                            /*if(porukaCtrl.text == "")
                            poruka = "";
                            else
                            poruka += porukaCtrl.text;*/


                            
                             await notifList.dodajObavestenje("Odobrena $kupovina", "Korisnik ${widget.rememberUser} je odobrio\nvas zahtev za kupovinom/rezervacijom\nproizvoda ${widget.naslov}.", widget.rememberUser, widget.cijeObavestenje, widget.datum, oznaka);

                             await notifList.oznaciKaoProcitano(widget.idObavestenja);
                              await notifList.kupiRezervisi(widget.cijeObavestenje, widget.rememberUser, widget.naslov, oznaka,widget.datum);

                             
                              
                            },
                            child: Center(child: Icon(Icons.assignment_turned_in_rounded))))),
                        SizedBox(width: 10,),
                        SizedBox(width: 40,height: 40,child: ElevatedButton(onPressed: () async {

                          if (odbijeno == false)
                            setState(() {
                              print('otvoreno');
                              print(odbijeno);
                              odbijeno = true;
                            });
                          else
                            setState(() {
                              print('Zatvoreno');
                              print(odbijeno);
                              odbijeno = false;
                            });
                        }, child: Center(child: Icon(Icons.block_outlined)))),
                      ],
                    ),
                        SizedBox(height: 15,),
                          Visibility(
                            visible: odbijeno,
                            child: Column(
                              children: [
                                Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),child: Column(
                                  children: [
                                    SizedBox(width: 250,height: 30,child: TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      controller: porukaCtrl,
                                      decoration: InputDecoration(hintText: 'Navedite razlog odbijanja'),
                                    )),
                                    SizedBox(height: 5,),
                                  ],
                                )),
                                SizedBox(height: 10,),
                                ElevatedButton(onPressed: () async {
                                  if(povratno != 1) {
                                    if(porukaCtrl.text != "")
                                    poruka = porukaCtrl.text;
                                    else
                                    poruka = "Nije naveden";
                                    await notifList.dodajObavestenje("Odbijena $kupovina", "Korisnik ${widget.rememberUser} je odbio\nvas zahtev za kupovinom/rezervacijom\nproizvoda ${widget.naslov}. Razlog odbijanja: $poruka", widget.rememberUser, widget.cijeObavestenje, widget.datum, oznaka);

                                    await notifList.oznaciKaoProcitano(widget.idObavestenja); }
                                  else
                                    await  notifList.oznaciKaoProcitano(widget.idObavestenja);
                                }, child: Text("Potvrdi")),
                                SizedBox(height: 15,),
                              ],
                            ),
                          ),

                        ],
                      ),
                    Expanded(child: SizedBox(width: 10,)),
                    
                    Expanded(child: SizedBox(height: 10,))
                  ],

                ),
              ),
              SizedBox(height: 10,),

            ],
        ),

    );
        else return Container(
          ///KUPAC
          child: Column(
            children: <Widget>[

              Container(
                color: (oznaka.toInt() == 0 ? Colors.green[100] : Colors.orange[100]),  ///OVDE SE BOJI DA BI SE RAZLIKOVALA OBAVESTENJA
                child: Row(
                  children: [
                    //SizedBox(width: 5,),
                    //Image.asset('images/$slika',width: 100,height: 100,),
                    Expanded(child: SizedBox(width: 10,)),
                    Column(

                      children: <Widget>[

                        SizedBox(height: 10,),
                        //Text("" + this.widget.sadrzaj.split('\n')[0],textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold), ),
                        Text("* " + this.widget.naslov + "*",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

                        SizedBox(height: 5,),
                        Row(children: [
                          Text("" + this.widget.sadrzaj.split('\n')[0].split(' ')[0]),
                          Text(" " + this.widget.sadrzaj.split('\n')[0].split(' ')[1],style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(" " + this.widget.sadrzaj.split('\n')[0].split(' ')[2]),
                          Text(" " + this.widget.sadrzaj.split('\n')[0].split(' ')[3]),
                        ],),
                        Row(children: [
                          Text(" " + this.widget.sadrzaj.split('\n')[1]),
                        ],),
                        //Text(" " + this.widget.naslov, textAlign: TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                        Row(
                          children: [
                            Text(" " + this.widget.sadrzaj.split('\n')[2].split('.')[0] + "."),
                          ],
                        ),
                        Row(
                          children: [
                            Text(" " + this.widget.sadrzaj.split('\n')[2].split('.')[1]),
                          ],
                        ),
                        //Text(" *" + this.widget.sadrzaj.split('\n')[3] + "* ", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, )),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              //color: Colors.green,
                              //margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              //decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent,),borderRadius: BorderRadius.all(Radius.circular(20))),

                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      //Text("" + this.widget.sadrzaj.split('\n')[4].split(':')[0] + ": ", style: TextStyle(fontStyle: FontStyle.italic),),
                                      //Text("" + this.widget.sadrzaj.split('\n')[4].split(":")[1]),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      //Text("" + this.widget.sadrzaj.split('\n')[5].split(": ")[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                      //Text("" + this.widget.sadrzaj.split('\n')[5].split(": ")[1]),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      //Text("" + this.widget.sadrzaj.split('\n')[6].split(':')[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                      //Text("" + this.widget.sadrzaj.split('\n')[6].split(':')[1]),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      //Text("" + this.widget.sadrzaj.split('\n')[7].split(':')[0] + ": ",style: TextStyle(fontStyle: FontStyle.italic),),
                                      //Text("" + this.widget.sadrzaj.split('\n')[7].split(':')[1]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(" " + this.widget.datum, textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        Text("Opcije: "),
                        SizedBox(height: 10,),
                        //Text("Poruka za $kupca",textAlign: TextAlign.left,),


                        Row(
                          children: [
                            
                            SizedBox(width: 10,),
                            SizedBox(width: 40,height: 40,child: ElevatedButton(onPressed: () async {

                             debugPrint("Cije obavestenje: " + widget.cijeObavestenje);
                             debugPrint("User: " + widget.rememberUser);   

                             var i=0;
                             var proizvod = ""; //= widget.sadrzaj.split("\n")[2].split(' ')[1];// " " + widget.sadrzaj.split("\n")[2].split(' ')[2];
                             debugPrint(widget.sadrzaj.split('\n')[2].split(' ').last);
                             while(true)
                             {
                               i++;
                              
                               if(widget.sadrzaj.split("\n")[2].split(' ')[i] == widget.sadrzaj.split("\n")[2].split(' ').last)
                               {
                                 proizvod =  proizvod + widget.sadrzaj.split("\n")[2].split(' ').last;
                                 break;
                               }
                               else
                                 proizvod = proizvod + widget.sadrzaj.split("\n")[2].split(' ')[i] + " ";


                             }
                             
                             proizvod = proizvod.replaceAll('.'," ");
                             proizvod = proizvod.trim();
                             debugPrint(proizvod);

                              if(widget.naslov.contains('Odobrena') &&  oznaka.toInt() == 2)
                              {

                                for(var i=0;i<adList.allAds.length; i++)
                   {
                           if(adList.allAds[i].name == proizvod && adList.allAds[i].user == widget.cijeObavestenje)
                           { cena = adList.allAds[i].price;
                             debugPrint("Cena " + cena.toString());
                              break;
                           }
                           
                   }              
                                  cena = double.parse(cena);
                                  cena = cena * Config.EthPrice;
                                  debugPrint("Cena " + cena.toString());
                                  debugPrint("Skinuti novac sa racuna!");
                                  bool imaWallet = false;
                                  String kupacPublicKey;
                                  for(var i=0;i<notifList.walletsCount;i++)
                                  {
                                    if(notifList.wallets[i].username == widget.rememberUser)
                                      {
                                              imaWallet = true;
                                              kupacPublicKey = notifList.wallets[i].publicKey;
                                              break;
                                            }
                                          }
                                  if(imaWallet)
                                  {
                                    debugPrint("Prosla kupovina kriptovalutom. ");
                                    UsersWallet usersWallet = new UsersWallet(widget.rememberUser);
                                    usersWallet.getAdress();
                                   // Credentials cred = await usersWallet.getCredentialsfromUserName(widget.cijeObavestenje);
                                    String prodavacPublicKey;
                                    for(var i=0;i<notifList.walletsCount;i++)
                                  {
                                    if(notifList.wallets[i].username == widget.cijeObavestenje)
                                      {
                                              prodavacPublicKey = notifList.wallets[i].publicKey;
                                              break;
                                            }
                                          }
                                   await usersWallet.transactEthers(kupacPublicKey,prodavacPublicKey,EtherAmount.fromUnitAndValue(EtherUnit.ether, 1));
                                  debugPrint(await usersWallet.getBalance(kupacPublicKey));
                                  debugPrint(await usersWallet.getBalance(prodavacPublicKey));
                                  }

                              }
                                  await  notifList.oznaciKaoProcitano(widget.idObavestenja);
                                  
                              }


                            , child: Center(child: Icon(Icons.highlight_remove)))),
                          ],
                        ),
                        SizedBox(height: 15,),
                        /*Visibility(
                          visible: odbijeno,
                          child: Column(
                            children: [
                              Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),child: Column(
                                children: [
                                  SizedBox(width: 250,height: 30,child: TextField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: porukaCtrl,
                                    decoration: InputDecoration(hintText: 'Navedite razlog odbijanja'),
                                  )),
                                  SizedBox(height: 5,),
                                ],
                              )),
                              SizedBox(height: 10,),
                              ElevatedButton(onPressed: () async {
                                if(povratno != 1) {
                                  if(porukaCtrl.text != "")
                                    poruka = porukaCtrl.text;
                                  else
                                    poruka = "Nije naveden";
                                  await notifList.dodajObavestenje("Odbijena $kupovina", "Korisnik ${widget.rememberUser} je odbio\nvas zahtev za kupovinom/rezervacijom\nproizvoda ${widget.naslov}. Razlog odbijanja: $poruka", widget.rememberUser, widget.cijeObavestenje, widget.datum, oznaka);

                                  await notifList.oznaciKaoProcitano(widget.idObavestenja); }
                                else
                                  await  notifList.oznaciKaoProcitano(widget.idObavestenja);
                              }, child: Text("Potvrdi")),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),*/

                      ],
                    ),
                    Expanded(child: SizedBox(width: 10,)),

                    Expanded(child: SizedBox(height: 10,))
                  ],

                ),
              ),
              SizedBox(height: 10,),

            ],
          ),

        );
  }
}
