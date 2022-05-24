import 'package:flutter/material.dart';

class DropDownCena extends StatefulWidget {
  @override
  _DropDownCenaState createState() => _DropDownCenaState();
}

class _DropDownCenaState extends State<DropDownCena> {

  String _chosenValue;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(

              value: _chosenValue,
              elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,

              items:<String>[
                'Rastuca',
                'Opadajuca'
              ].map <DropdownMenuItem<String>>((String value)
              {
                return DropdownMenuItem<String>
                  (
                  value: value,
                  child: SizedBox(width:180,child: Center(child: Text(value,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Cursive'),))),
                );
              }).toList(),

              onChanged: (String value) {
                setState(() {
                  _chosenValue = value;
                });
              }

          ),
        ),
      ),
    );
  }
}



