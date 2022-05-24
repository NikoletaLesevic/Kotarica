// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moja stranica',
      home: Scaffold(
        appBar: AppBar(
          title: Text('HOMEPAGE', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.black,
          centerTitle: true,
          toolbarHeight: 120,
        ),
        body: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Container(
                height: 200,
                color: Colors.amber[600],
                child: const Center(child: Icon(Icons.computer, color: Colors.black, size: 200.0)),
              ),
              Container(
                height: 200,
                color: Colors.amber[500],
                child: const Center(child: Text('TechLab', style: TextStyle(fontSize: 30.0),),),
              ),
              Container(
                height: 200,
                color: Colors.amber[200],
                //child: const Center(child: Text('David Dašić 62-2018')),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image(image: AssetImage('images/img1.jpg')),
                    ),
                    Expanded(
                      child: Image(image: AssetImage('images/img2.jpg')),
                    ),
                  ],
                )
              ),
            ],
          )
        //body: Center(
          //child: Text('Hello World', style: TextStyle(fontSize: 20.0),),
          //child: Icon(Icons.computer, color: Colors.black, size: 200.0),
        //),
      ),
    );
  }
}

