
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/oglas/oglas.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



//za moje kupljene proizvode, tj proizvode koje sam kupila

class prikazKupovine extends StatelessWidget {
  //final String kratakOpis;
  //final String slika;
  //final double cena;
  //final String imeProizvoda;
  //final String vlasnik;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  int ocena;
  var komentar;
  final BigInt id;
  final String kupac;
  final String vlasnik;
  final String nazivProizvoda;
  final BigInt vrstaKupovine;
  final String datum;
 final bool ocenjeno;
 final bool komentarisano;

   prikazKupovine(
      {Key key,
      this.id,
      this.kupac,
      this.vlasnik,
      this.nazivProizvoda,
      this.vrstaKupovine,
      this.datum,
      this.ocenjeno,
      this.komentarisano})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listNotif = Provider.of<NotificationListModel>(context);
      var listAd = Provider.of<AdListModel>(context);

    String kupVrsta;
    if(this.vrstaKupovine.toInt() == 0)
    kupVrsta = 'Rezervacija';
    else if(this.vrstaKupovine.toInt() == 1)
    kupVrsta = 'Kupovina pouzecem';
    else if(this.vrstaKupovine.toInt() == 2)
    kupVrsta = 'Kupovina kriptovalutom';


    return Column(
      children: [
        GestureDetector(
          onTap: () {
            
          },
          child: Container(
            color: (this.vrstaKupovine.toInt() == 0) ? Colors.yellow[200] : Colors.green[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(8.0),
              //color: Colors.blueAccent,
              child: Row(
                children: [
                  
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                                child: Center(
                                    child: Text('Proizvod: ' +
                          this.nazivProizvoda,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        )))),
                        Expanded(
                            child: Container(
                                child: Center(
                                    child: Text('Prodavac: ' + 
                          this.vlasnik,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )))),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: Text(
                              'Vrsta kupovine: '  + kupVrsta,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.orange[900]),
                              textAlign: TextAlign.left,
                            ))),
                            Text(this.datum, textAlign: TextAlign.center, style:TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  Column( children: [
                    SizedBox(height: 3,),
                ElevatedButton(
                      child:  Text(this.ocenjeno ? 'Ocenjeno' : 'Ocenite\nproizvod'),                                            
                      onPressed:  () {        

                        this.ocenjeno == false ?
                               showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Ocenite proizvod', style: TextStyle(fontSize: 18),),
                                content: Form(                                  
                                    key: _formKey,
                                  child: TextFormField(                                    
                                    validator: (value) {
                                                            
                                       if(value.isEmpty || int.parse(value) < 1 || int.parse(value) > 5)
                                       return 'Neispravan unos!';       
                                       else            
                                       return null;          },
                                  onSaved: (String value){
                                    ocena = int.parse(value);
                                  },
                                  style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                                         
                                ),                                
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        
                                        
                                          if(_formKey.currentState.validate())
                                        _formKey.currentState.save();

                                        await listAd.oceniOglas(nazivProizvoda, vlasnik, BigInt.from(ocena));
                                        debugPrint(ocena.toString());
                                        await listNotif.prebaciUOcenjeon(this.id);
                                        //ocenjeno = true;
                                        Navigator.pop(context);

                                        
                                        
                                      },
                                      child: Text('Oceni'))
                                ],
                              )) : 
                          showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Ocenite proizvod', style: TextStyle(fontSize: 18),),
                                content: Text("Vec ste ocenili proizvod!",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),                          
                            
                                actions: [
                                  TextButton(
                                      onPressed: ()  {
                                        if(this.ocenjeno)
                                        {
                                            debugPrint("Vec ocenjeno");
                                            Navigator.pop(context);
                                        }
                                        

                                                                              
                                      },
                                      child: Text('OK'))
                                ],
                              ));


                                         //dodati za ocenjivanje
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange[200]
                      ),
                      ),
                                          SizedBox(height: 10,),
                  ElevatedButton(
                    child: Text( this.komentarisano ? 'Ostavljen komentar'  : 'Ostavite\nkomentar'),
                  style: ElevatedButton.styleFrom(
                        primary: Colors.orange[200]),
                    
                    onPressed: () async {

                   if( this.komentarisano == false) {

                      await listNotif.prebaciUKomentarisano(this.id);
                      
                      Ad proizvod;
                      for(var i=0; i< listAd.allAds.length;i++)
                      {
                          if(listAd.allAds[i].name == nazivProizvoda && listAd.allAds[i].user == vlasnik)
                          {
                            proizvod = new Ad(user: listAd.allAds[i].user,
                                              name: listAd.allAds[i].name,
                                              price: listAd.allAds[i].price,
                                              picHash: listAd.allAds[i].picHash,
                                              description: listAd.allAds[i].description,
                                              contact: listAd.allAds[i].contact,
                                              category: listAd.allAds[i].category,
                                            
                            );
                            break;
                          }
                      }

                      Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (Oglas(
                          name: proizvod.name,
                          price: proizvod.price.toString(),
                          image: proizvod.picHash,
                          description: proizvod.description,
                          owner: proizvod.user,
                          category: proizvod.category,
                          smeDaKomenatarise: true,
                        ))));

                               /*showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Ostavite komentar', style: TextStyle(fontSize: 18),),
                                content: Form(                                  
                                    key: _formKey2,
                                  child: TextFormField(                                    
                                    validator: (value) {
                                                            
                                       if(value.isEmpty)
                                       return 'Neispravan unos!';       
                                       else            
                                       return null;          },
                                  onSaved: (String value){
                                    this.komentar = value;
                                  },
                                  style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                                         
                                ),                                
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        
                                        
                                          if(_formKey2.currentState.validate())
                                        _formKey2.currentState.save();

                                        //await listAd.oceniOglas(nazivProizvoda, vlasnik, BigInt.from(ocena));
                                        debugPrint(komentar);
                                        await listNotif.prebaciUKomentarisano(this.id);
                                        //ocenjeno = true;
                                        Navigator.pop(context);                                        
                                        
                                      },
                                      child: Text('Komentarisi'))
                                ],
                              )); */}  else { showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Ostavite komentar', style: TextStyle(fontSize: 18),),
                                content: Text("Vec ste komentarisali proizvod!",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),                          
                            
                                actions: [
                                  TextButton(
                                      onPressed: ()  {
                                       
                                            debugPrint("Vec komentarisano");
                                            Navigator.pop(context);                                        
                                                                                                                      
                                      },
                                      child: Text('OK'))
                                ],
                              )
                              );
                              }

                  }, ),
                ],
              )
              ]
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}