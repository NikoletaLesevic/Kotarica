import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/auth/LoginPage.dart';
import 'package:kotarica/auth/SignupPage.dart';
import 'package:kotarica/home/HomeStranica.dart';
import 'package:kotarica/storage/getstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/Footer.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/model/UserModel.dart';

String rememberUser;
bool zapamti=false;
TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
TextEditingController addrssCtrl2 = TextEditingController();
TextEditingController passwordCtrl2 = TextEditingController();
TextEditingController firstNameCtrl2= TextEditingController();
TextEditingController lastNameCtrl2 = TextEditingController();
TextEditingController emailCtrl2 = TextEditingController();
TextEditingController mobileCtrl2 = TextEditingController();

class ProfilePageData extends StatefulWidget {
  @override
  _ProfilePageDataState createState() => _ProfilePageDataState();
}

class _ProfilePageDataState extends State<ProfilePageData> {
  PickedFile imageFile;

  Future importImage(ImageSource source) async {
    PickedFile picture = await ImagePicker().getImage(source: source);
    if (picture != null) {
      imageFile = picture;
    }
    setState(() {
      //getPref();
    });
  }

  @override
  Widget build(BuildContext context) {
    //getPref();
    //ucitajPodatke();    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: bodyContent(),
      bottomNavigationBar: Footer(),
    );
    
  }

  Widget bodyContent() {
  var listM = Provider.of<UserModel>(context);
  var i=0; 

  //getPref();
  if(zapamti)
  {
    int br = listM.userCount;
    for(var i=0;i<br;i++)
    {
      if(listM.users[i].userName == rememberUser)
      {
          userNameCtrl.text = listM.users[i].userName;
          passwordCtrl.text = listM.users[i].password;
          firstNameCtrl.text = listM.users[i].firstName;
          lastNameCtrl.text = listM.users[i].lastName;
          emailCtrl.text = listM.users[i].mail;
          mobileCtrl.text = listM.users[i].mobile;
          addressCtrl.text = listM.users[i].adresa;
          break;
      }
    }
  }
    return Material(child: FutureBuilder(future: getPref(),
    builder: (context,snapshot) {
      if(zapamti)
  {
    int br = listM.userCount;
    for(var i=0;i<br;i++)
    {
      if(listM.users[i].userName == rememberUser)
      {
          userNameCtrl.text = listM.users[i].userName;
          passwordCtrl.text = listM.users[i].password;
          firstNameCtrl.text = listM.users[i].firstName;
          lastNameCtrl.text = listM.users[i].lastName;
          emailCtrl.text = listM.users[i].mail;
          mobileCtrl.text = listM.users[i].mobile;
          addressCtrl.text = listM.users[i].adresa;
          break;
      }
    }
  }
    return Column(
      
      children: [
        Container(
          height: 300.0,
          color: Colors.orange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.0),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [imageProfile(context)],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                zapamti ? rememberUser : "@korisnickoime",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Ime:",
                
                  controller: firstNameCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Ime"),
                  
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: firstNameCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Promenite ime"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: lastNameCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Prezime"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: lastNameCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Promenite prezime"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Adresa za dostavu:",
                  controller: addressCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Adresa za dostavu"),
                ),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Adresa za dostavu:",
                  controller: addrssCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Nova adresa za dostavu"),
                ),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                 SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Mobilni telefon:",
                  controller: mobileCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Mobilni telefon")),

                
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: mobileCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Promenite broj telefona"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Email:",
                  controller: emailCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Email"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: emailCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Promenite email adresu"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                  //"Korisničko ime:",
                  controller: userNameCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Korisnicko ime"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextField(
                 // "Lozinka:",
                 controller: passwordCtrl,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Lozinka"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: TextField(
                  //"Prezime:",
                  controller: passwordCtrl2,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(labelText: "Promenite lozinku"),
                ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[150],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                        debugPrint(addrssCtrl2.text);
                        listM.updateUser(rememberUser,passwordCtrl2.text, firstNameCtrl2.text, lastNameCtrl2.text,mobileCtrl2.text,emailCtrl2.text,addrssCtrl2.text);
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeStranica()));
                  },
                  child: Text(
                    "Izmeni podatke",
                    style: TextStyle(fontSize: 23.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[200],
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ],
            ),
          ),
        ),
      ],
    ); }
    ));
    
  }

  Widget imageProfile(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: imageFile == null
              ? AssetImage("images/profile.png")
              : FileImage(File(imageFile.path)),
        ),
        Positioned(
            bottom: 20.0,
            right: 7.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet(context)));
              },
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 35.0,
                color: Colors.white70,
              ),
            ))
      ],
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "Izaberi profilnu fotografiju",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  importImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Kamera"),
              ),
              TextButton.icon(
                onPressed: () {
                  importImage(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Galerija"),
              )
            ],
          )
        ],
      ),
    );
  }
} 

getPref() async {
  GetStorageHelper gh = new GetStorageHelper();
    var user = gh.readUsername();
    rememberUser = user;
    if(user != null) {
      zapamti=true;
    }
}
