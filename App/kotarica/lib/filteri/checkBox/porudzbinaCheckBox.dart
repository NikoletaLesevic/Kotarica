import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class porudzbinaCheckBox extends StatefulWidget {
  const porudzbinaCheckBox({Key key}) : super(key: key);

  bool get getMogucnostPorudzbine => _porudzbinaCheckBoxState().getMogucnostPorudzbine();

  @override
  _porudzbinaCheckBoxState createState() => _porudzbinaCheckBoxState();
}

/// This is the private State class that goes with porudzbinaCheckBox.
class _porudzbinaCheckBoxState extends State<porudzbinaCheckBox> {

  static bool mogucnostPorudzbine = false;

  bool getMogucnostPorudzbine (){ return mogucnostPorudzbine; }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[300],
      child: SizedBox(
        height: 70,
        child: Center(
          child: CheckboxListTile(
            title: const Text('Mogucnost porudzbine'),
            activeColor: Colors.lightBlue,
            value: timeDilation != 1.0,
            onChanged: (bool value) {
              setState(() {
                timeDilation = value ? 1.5 : 1.0;
                promeni();
              });
            },
            secondary:SizedBox(width:40,height:40,child: Image.asset('images/orderIcon.png')),

          ),
        ),
      ),
    );
  }

  void promeni() {
      if (mogucnostPorudzbine == false)
        mogucnostPorudzbine = true;
      else
        mogucnostPorudzbine = false;
  }
}
