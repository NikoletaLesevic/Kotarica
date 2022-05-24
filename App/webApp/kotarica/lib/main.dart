import 'dart:io';
import 'dart:ui';

import 'package:kotarica/auth/LoginPage.dart';
import 'package:kotarica/chat/chat.dart';
import 'package:kotarica/chat/chats.dart';
import 'package:kotarica/form/form_screen.dart';
import 'package:kotarica/home/HomeStranica.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/model/NotificationModel.dart';
import 'package:kotarica/oglas/Kupovina.dart';
import 'package:kotarica/profile/profile.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:kotarica/wishlist/wishlist.dart';
import 'package:kotarica/signalr/signal_helper.dart';
import 'package:provider/provider.dart';
import 'model/AdModel.dart';
import 'model/UserModel.dart';
import 'auth/SignupPage.dart';


String rememberUser;
bool zapamti = false;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  GetStorageHelper gh = new GetStorageHelper();
  await gh.initStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Ovaj vidzet je osnova aplikacije

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdListModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => SignalHelper()),
        ChangeNotifierProvider(create: (context) => NotificationListModel()),
      ],
      child: MaterialApp(
        title: 'Kotarica',
        theme: ThemeData(primarySwatch: Colors.orange),
        debugShowMaterialGrid: false,
        // home: HomeStranica(title: 'Kotarica'),
        routes: {
          '/': (context) => HomeStranica(),
          '/signup': (context) => SignInPage(),
          '/login': (context) => LogInPage(),
          '/prodaj': (context) => FormScreen(),
          '/profil': (context) => ProfilePage(),
          '/chats': (context) => Chats(),
          '/wishlist': (context) => Wishlist(),
          '/Kupovina': (context) => Kupovina(),
          // '/chat': (context) => Chat()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
