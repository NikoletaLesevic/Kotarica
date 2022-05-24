import 'package:flutter/material.dart';

class sliderCena extends StatefulWidget {
  RangeValues get getOpseg => _sliderCenaState().getRaspon();


  @override
  _sliderCenaState createState() => _sliderCenaState();
}

class _sliderCenaState extends State<sliderCena> {

  double trenutnaCena = 300.00;
  double maxCena = 2000.00;
  double minCena = 20.00;

  double donjaGranica = 20.00;
  double gornjaGranica = 700.00;
  static RangeValues rasponCena = RangeValues(20.00,700.00);

  RangeValues getRaspon(){return rasponCena;}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text("$donjaGranica - $gornjaGranica ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Cursive'),),
        //SizedBox(height: 10,),
        RangeSlider(
          activeColor: Colors.lightBlue,
            inactiveColor: Colors.lightBlue[200],
            values: rasponCena,
            onChanged: (RangeValues noviRaspon) {
                setState(() {
                      rasponCena = noviRaspon;
                      donjaGranica = noviRaspon.start.roundToDouble();
                      gornjaGranica = noviRaspon.end.roundToDouble();
                });
            },
            min: minCena,
            max: maxCena,
          //divisions: 10,
          //label: "$trenutnaCena",

        ),
      ],
    );
  }

}













