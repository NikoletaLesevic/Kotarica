import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Mini Gallery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
    int broj = 1;
    
    void sledeca()
    {
        setState(() {
            if (broj == 10)
              broj = 1;
            else
              broj++;
        });
    }
    
    void prethodna()
    {
        setState(() {
            if (broj == 1)
              broj = 10;
            else
              broj--;
        });
    }

  @override
  Widget build(BuildContext context) {

      //Izgled aplikacije

      return Scaffold(
        
          appBar: AppBar(title: Text(widget.title)),
          body: Center(
              child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      
                      Container(child: Expanded(child: Image(image: AssetImage('images/slika' + '$broj' + '.png')))),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        FloatingActionButton(onPressed: prethodna, tooltip: 'prethodna slika',child: Icon(Icons.arrow_left)),
                        FloatingActionButton(onPressed: sledeca,tooltip: 'sledeca slika',child: Icon(Icons.arrow_right))
                      ],)
                    
                  ],
                
              ),
          )
        
      );

  }
    
    
    
    
    
  
  
  
  
}
