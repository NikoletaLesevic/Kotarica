import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/oglas/oglas.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



//za proizvode koje sam ja prodala

class prikazProdaje extends StatelessWidget {
  //final String kratakOpis;
  //final String slika;
  //final double cena;
  //final String imeProizvoda;
  //final String vlasnik;

  final BigInt id;
  final String kupac; 
  final String vlasnik;
  final String nazivProizvoda;
  final BigInt vrstaKupovine;
  final String datum;

  const prikazProdaje(
      {Key key,
      this.id,
      this.kupac,
      this.vlasnik,
      this.nazivProizvoda,
      this.vrstaKupovine,
      this.datum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var listM = Provider.of<AdListModel>(context);
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
                                    child: Text('Kupac: ' + 
                          this.kupac,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )))),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: Text(
                              'Vrsta kupovine: '  + kupVrsta,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.orange[900]),
                              textAlign: TextAlign.left,
                            ))),
                            Text(this.datum, textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ElevatedButton(
                      child:  (this.vrstaKupovine.toInt() == 0) ? Icon(Icons.lock_clock) : Icon(Icons.assignment_turned_in_outlined),                                        
                      onPressed:  () {                         //dodati za ocenjivanje
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange[200]
                      ),
                      )
                ],
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