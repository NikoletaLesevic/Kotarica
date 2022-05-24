import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class razmenaCheckBox extends StatefulWidget {
  const razmenaCheckBox({Key key}) : super(key: key);

  bool get getMogucnostRazmene => _razmenaCheckBoxState().getMogucnostRazmene();

  @override
  _razmenaCheckBoxState createState() => _razmenaCheckBoxState();
}

/// This is the private State class that goes with razmenaCheckBox.
class _razmenaCheckBoxState extends State<razmenaCheckBox> {

  static bool razmena = false;

  bool getMogucnostRazmene() {return razmena;}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[300],
      child: SizedBox(
        height: 70,
        child: Center(
          child: CheckboxListTile(
            title: const Text('Mogucnost razmene'),
            activeColor: Colors.lightBlue,
            value: timeDilation != 1.0,
            onChanged: (bool value) {
              setState(() {
                timeDilation = value ? 1.5 : 1.0;
                promeni();
              });
            },
            secondary:SizedBox(width:40,height:40,child: Image.asset('images/switchIcon.png')),

          ),
        ),
      ),
    );
  }

  void promeni() {

    if (razmena == false)
      razmena = true;
    else
      razmena = false;

  }
}
