
//import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
        ),
        body: Center(
          child: Text(
            'My first app',
            style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      
                     
                      color: Colors.red
                    ),
          ),
        ),
    );
  }
}
  