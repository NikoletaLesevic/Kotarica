
import 'package:flutter/material.dart';
import 'package:kotarica/filteri/checkBox/porudzbinaCheckBox.dart';
import 'package:kotarica/filteri/checkBox/razmenaCheckBox.dart';
import 'package:kotarica/filteri/dropDown/dropDownGradovi.dart';
import 'package:kotarica/filteri/forma.dart';
import 'package:kotarica/filteri/slider/sliderCena.dart';
import 'package:kotarica/shared/Header.dart';

import 'dropDown/dropDownKategorije.dart';

class FilteriZaPretragu extends StatelessWidget {

    //double osnovnaCena = 300.00

  odabraniFilteri odabrani;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],

      appBar: Header(),
      body: Container(

        child: Column(

            ///Glavna kolona

            children: <Widget>[

              Container(
                color: Colors.orange[400],
                child: Row(

                  children: <Widget>[

                     Icon(Icons.filter_list_alt, size: 50),
                     Text('  Filteri',style: TextStyle(fontSize: 25),),
                     Expanded(child: SizedBox(height: 80,)),
                    Expanded(child: SizedBox(height: 80,)),


                    ElevatedButton(
                        ///Dugme PRIMENI

                        style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        onPressed: (){

                          odabrani = new odabraniFilteri(DropDownKategorije().getKategorija,DropDownGradovi().getGrad,sliderCena().getOpseg,porudzbinaCheckBox().getMogucnostPorudzbine,razmenaCheckBox().getMogucnostRazmene);
                          Navigator.pop(context,odabrani);

                        },
                        child: Text(
                          'Primeni',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),

                        )),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(

                ///Filter za kategorije

                color: Colors.orange[300],
                child: Row(
                  children: <Widget>[
                      SizedBox(height: 80,),
                      
                      SizedBox(height: 50,child: Image.asset('images/category.png',)),
                      Text('   Kategorija',style: TextStyle(fontSize: 20),),
                      Expanded(child: SizedBox()),
                    Container(child: DropDownKategorije()),
                  ],
                ),




              ),
              SizedBox(height: 5,),
              Container(
                
                ///Filter za Mesto/Grad
                
                color: Colors.orange[300],
                child: Row(
                  
                  children: <Widget>[
                    
                    SizedBox(height: 80,),
                    SizedBox(height: 50,child: Image.asset('images/cityIcon.png')),
                    Text('  Mesto/Grad',style: TextStyle(fontSize: 20),),
                     Expanded(child: SizedBox()),
                     Container(child: DropDownGradovi()),


                  ],
                  
                ) 
              
              ),
              SizedBox(height: 5,),
              Container(

                ///Filter za Cenu

                color: Colors.orange[300],
                child: Row(

                  children: <Widget>[

                    SizedBox(height: 80,),
                    SizedBox(height: 50,child: Image.asset('images/priceIcon.png')),
                    Text('  Cena',style: TextStyle(fontSize: 20),),
                    Expanded(child: SizedBox()),

                    sliderCena(),

                  ],
                ),

              ),
              SizedBox(height: 5,),
              porudzbinaCheckBox(),
              SizedBox(height: 5,),
              razmenaCheckBox(),
              
            ],


        )



      ),



    );
  }


}
