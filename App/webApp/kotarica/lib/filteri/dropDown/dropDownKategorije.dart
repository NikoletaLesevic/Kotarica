import 'package:flutter/material.dart';

class DropDownKategorije extends StatefulWidget {
  String get getKategorija => _DropDownKategorijeState().getKategorija();

  @override
  _DropDownKategorijeState createState() => _DropDownKategorijeState();
}

class _DropDownKategorijeState extends State<DropDownKategorije> {

  static String _chosenValue;

  String getKategorija(){ return _chosenValue;}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(

            value: _chosenValue,
            elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,

            items:<String>[
              'Voce i povrce',
                'Mleko i mlecni proizvodi',
              'Med',
              'Meso',
            ].map <DropdownMenuItem<String>>((String value)
            {
              return DropdownMenuItem<String>
                (
                value: value,
                child: SizedBox(width:180,child: Center(child: Text(value,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontFamily: 'Fantasy',fontSize: 20),))),
              );
            }).toList(),

            onChanged: (String value) {
              setState(() {
                _chosenValue = value;
              });
            }

        ),
      ),
    );
  }
}
