import 'package:flutter/material.dart';

class DropDownKategorije extends StatefulWidget {
  String get getKategorija => _DropDownKategorijeState().getKategorija();

  @override
  _DropDownKategorijeState createState() => _DropDownKategorijeState();
}

class _DropDownKategorijeState extends State<DropDownKategorije> {

  static String _kategorija;

  String getKategorija(){ return _kategorija;}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(

            value: _kategorija,
            elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,

            items:<String>[
              'Izaberi kategoriju',
              'Meso i mesne preradjevine',
              'Mleko i mlecni proizvodi',
              'Voce',
              'Povrce',
              'Bilje i gljive',
              'Dzem',
              'Ajvar',
              'Med',
              'Ulje',
              'Namaz',
              'Slatkisi',
              'Vino',
              'Rakija',
              'Domaci sok',
              'Caj',
              'Odeća i proizvodi od tekstila',
              'Kozmetika i sredstva za higijenu',
              'Namestaj',
              'Korpe',
              'Cvece',
              'Ostalo',
            ].map <DropdownMenuItem<String>>((String value)
            {
              return DropdownMenuItem<String>
                (
                value: value,
                child: SizedBox(width:180,child: Center(child: Text(value,style: TextStyle(color: Colors.black,fontFamily: 'Fantasy',fontSize: 16),))),
              );
            }).toList(),

            onChanged: (String value) {
              setState(() {
                _kategorija = value;
              });
            }

        ),
      ),
    );
  }
}
