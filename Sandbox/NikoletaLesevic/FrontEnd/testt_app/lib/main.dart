import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Center(child: Text("Fire")),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(
              'https://realtimevfx.com/uploads/default/original/2X/4/4b7907961e71c1dcc45e11cea8eae852d7a9ab39.gif',
            ),
          ),
        ),
      ),
    ),
  );
}
