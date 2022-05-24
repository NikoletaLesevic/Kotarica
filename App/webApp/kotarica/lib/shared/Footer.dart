import 'package:flutter/material.dart';
import 'package:kotarica/profile/profile.dart';

class Footer extends StatelessWidget {
  ///DONJI DEO STRANICE

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //Donji deo stranice za navigaciju

      color: Colors.grey[300],
      child: SizedBox(
        height: 50,
        child: Row(
          //Red dugmica na donjem delu stranice

          children: <Widget>[
            Expanded(
                child: ElevatedButton(

                    /// Dugme za 'Home'

                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[300], elevation: 0),
                    child: Container(
                      //Probni kontainer
                      //color: Colors.red,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Opacity(
                              opacity: 0.3,
                              child: Image.asset(
                                'images/homeIcon.png',
                                height: 20,
                                width: 30,
                              )),
                          Opacity(opacity: 0.3, child: Text('Pocetna')),
                        ],
                      ),
                    ),
                    onPressed: () => {
                    Navigator.pushNamed(context, '/login')
                    })),
            Expanded(
                child: ElevatedButton(

                    ///Dugme za 'Prodaj'

                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[300], elevation: 0),
                    child: Container(
                      //color: Colors.blueAccent,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Opacity(
                              opacity: 0.3,
                              child: Image.asset(
                                'images/prodajIcon.png',
                                height: 20,
                                width: 30,
                              )),
                          Opacity(opacity: 0.3, child: Text('Prodaj')),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/prodaj');
                    })),
            Expanded(
                child: ElevatedButton(

                    /// Dugme za 'Profil'

                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[300], elevation: 0),
                    child: Container(
                      //color: Colors.yellow,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Opacity(
                              opacity: 0.3,
                              child: Image.asset(
                                'images/userIcon.png',
                                height: 20,
                                width: 30,
                              )),
                          Opacity(opacity: 0.3, child: Text('Auth')),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                    })),
          ],
        ),
      ),
    );
  }
}
