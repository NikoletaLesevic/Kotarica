//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/chat/chats.dart';
import 'package:kotarica/home/HomeStranica.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/shared/Header.dart';
import 'package:provider/provider.dart';

class Kupovina extends StatefulWidget {

  String name;
   String price;
   String owner;
  String rememberUser;
  String date;
  Kupovina({this.name, this.price, this.owner, this.rememberUser,this.date});
  @override
  _KupovinaState createState() => _KupovinaState(name,price,owner,rememberUser,date);
}

class _KupovinaState extends State<Kupovina> {

   String name;
   String price;
   String owner;
   String rememberUser;
   String date;
   _KupovinaState(this.name,this.price, this.owner,this.rememberUser,this.date); 

  String _ime;
  String _prezime;
  String _adresa;
  String _grad;
  String _postanskiBroj;
  String _mesto;
  String _brojTelefona;
  DateTime _datum;

  int RadioGrupa = 1;
  bool cekirano = false;
  String tekstDugmeta = 'Kupi';
  String datum = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildImeField(){  ///Ime

    return TextFormField(

        decoration: InputDecoration(
          labelText: 'Ime',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),),
        validator: (String value) {

            if (value.isEmpty)
            {
               return 'Ime je neophodno';
            }
            return null;
        },
        onSaved: (String value){
          _ime = value;
        },


    );
  }

  Widget _buildPrezimeField(){  ///Prezime

    return TextFormField(

      decoration: InputDecoration(
        labelText: 'Prezime',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),),
      validator: (String value){

          if (value.isEmpty)
          {
              return 'Prezime je neophodno' ;
          }
          return null;
      },

      onSaved: (String value){
        _prezime = value;
      },

    );
  }

  Widget _buildAdresaField(){  ///Adresa

    return TextFormField(

        decoration: InputDecoration(
            labelText: 'Adresa',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),),
        validator: (String value){
          if (value.isEmpty)
            {
              return 'Adresa je neophodna';
            }
          return null;
        },

      onSaved: (String value) {
        _adresa = value;
      }
    );
  }

  Widget _buildGradField(){  ///Grad

    return TextFormField(


      decoration: InputDecoration(
        labelText: 'Opstina',
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),),
      validator: (String value) {
          if (value.isEmpty)
            return 'Opstina je neophodna';

            return null;
      },

      onSaved: (String value)
      {
          _grad = value;
      },
    );

  }

  Widget _buildPostaField(){  ///Postanski broj

    return TextFormField(

      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter((5))],
      keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Postanski broj',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),),
        validator: (String value){
            if (value.isEmpty)
              return 'Postanski broj je neophodan';
            else if (double.tryParse(value) == null)
              return 'Morate uneti broj';
            else 
              return null;
        },

      onSaved: (String value){
          _postanskiBroj = value;
      },

    );
  }

  Widget _buildMestoField(){  ///Mesto

    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Mesto',
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        ),
        validator: (String value)
      {
          if (value.isEmpty)
            return 'Mesto je neophodno';

          return null;
      },
      onSaved: (String value){
          _mesto = value;
      },
    );
    
  }

  Widget _buildTelefonField(){  ///Broj Telefona

    return TextFormField(

        inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter((10))],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Broj telefona',
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),),
        validator: (String value){
            if (value.isEmpty)
              return 'Broj telefona je neophodan';
            else if (double.tryParse(value) == null)
              return 'Morate uneti broj';
             else return null;
        },

      onSaved: (String value)
      {
          _brojTelefona = value;
      }
    );
  }


  @override
  Widget build(BuildContext context) {

    var obavestenjaModel = Provider.of<NotificationListModel>(context);
    bool imaWallet = false;
    for(var i=0;i<obavestenjaModel.walletsCount;i++)
    {
      if(obavestenjaModel.wallets[i].username == owner)
      {
        imaWallet = true;
        break;
      }
    }

    return Scaffold(

      appBar: Header(),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Align(alignment: Alignment.centerLeft,child: Text('Popunite detalje za porudzbinu',style: TextStyle(fontSize: 20),)),
                  SizedBox(height: 10,),
                  _buildImeField(),
                  SizedBox(height: 20,),
                  _buildPrezimeField(),
                SizedBox(height: 20,),
                  _buildAdresaField(),
                SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(child: SizedBox(child: _buildGradField())),
                      SizedBox(width: 20,),
                      Expanded(child: SizedBox(width: 100,child: _buildPostaField())),
                      SizedBox(width: 20,),
                    ],
                  ),
                SizedBox(height: 20,),
                SizedBox(child: _buildMestoField()),
                SizedBox(height: 20,),

                  ///Fali mesto
                _buildTelefonField(),
                SizedBox(height: 20,),

                SizedBox(

                  ///Nacini placanja
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(

                      children: <Widget>[
                        Row(
                          children: [
                            Text('Nacin placanja',style: TextStyle(fontSize: 18),),
                            Expanded(child: SizedBox(width: 20,)),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Column(

                          children: [
                            Row(
                              children: [
                                  Image.asset('images/PouzeceIcon.png',height:50 ,width:50 ,),
                                  Radio(value: 1, onChanged: (T){
                                    setState(() {
                                      RadioGrupa = T;
                                    });
                                  }, groupValue: RadioGrupa,),
                                  Text('Pouzecem',style: TextStyle(fontSize: 15),),
                              ],
                            ),
                            SizedBox(width: 20,),
                            imaWallet==false ? Text("") : 
                            Row(
                              children: [

                                Image.asset('images/BitcoinIcon.png',height: 50,width: 50,),
                                Radio(value: 2,onChanged: (T){
                                  setState(() {
                                    RadioGrupa = T;
                                  });
                                },groupValue: RadioGrupa,),
                                Text('Kriptovalutom',style: TextStyle(fontSize: 15),),



                              ],
                            )
                          ],

                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [

                            Checkbox(value: cekirano, onChanged: (T){
                              setState(() {
                                cekirano = T;
                                if (cekirano == true)
                                  tekstDugmeta = 'Rezervisi';
                                else
                                  tekstDugmeta = 'Kupi';
                              });
                                if (cekirano == true) {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2025),
                                  ).then((value){
                                    setState(() {
                                      _datum = value;
                                      debugPrint(_datum.toString());
                                      date=_datum.toString();
                                      debugPrint(date);
                                    });
                                  });
                                }



                            }),
                            Text('Rezervacija',style: TextStyle(fontSize: 18),),



                          ],
                        )

                      ],


                    ),
                  ),
                ),


                SizedBox(height: 20,),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      child: Text('$tekstDugmeta'),

                    onPressed: (){
                        if(!_formKey.currentState.validate()){
                          return;
                        }

                        _formKey.currentState.save();
                    var kupovinaVrsta;
                    var sifra;
                    if(RadioGrupa == 1){
                    sifra = 1;
                    kupovinaVrsta = 'Pouzecem'; }
                    else if(RadioGrupa == 2){
                    kupovinaVrsta = 'Kriptovalutom';
                    sifra=2;
                    }
                  

                    if(tekstDugmeta == "Rezervisi"){
                    if(rememberUser != owner)
                    obavestenjaModel.dodajObavestenje("$name","Nova rezervacija!\nKorisnik $rememberUser \nzeli da rezervise proizvod : $name.\nNjegovi podaci: \nIme i prezime: $_ime  $_prezime\nAdresa: $_adresa $_postanskiBroj $_grad\nMobilni: $_brojTelefona\nNacin placanja: $kupovinaVrsta " , rememberUser, owner, date,BigInt.from(0));
                    Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomeStranica()));
                    }
                    else if(tekstDugmeta == "Kupi"){
                    if(rememberUser != owner)
                    obavestenjaModel.dodajObavestenje("$name","Nova kupovina!\nKorisnik $rememberUser \nzeli da kupi proizvod : $name. \nNjegovi podaci: \nIme i prezime: $_ime  $_prezime\nAdresa: $_adresa $_postanskiBroj $_grad\nMobilni: $_brojTelefona\nNacin placanja: $kupovinaVrsta " , rememberUser, owner,DateTime.now().toString(),BigInt.from(sifra));
                    Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomeStranica()));
                    }
                    },
                  ),
                )

              ],
            ),
          ),
        ),

      ),



    );
  }
}
