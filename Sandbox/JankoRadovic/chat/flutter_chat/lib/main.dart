import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final serverUrl = "http://10.0.2.2:5000/chathub";
  HubConnection hubConnection;
  final firstUser = TextEditingController();
  final secondUser = TextEditingController();
  final message = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text('First user', style: TextStyle(fontSize: 20)),
          TextField(
            controller: firstUser,
          ),
          Text('Second user', style: TextStyle(fontSize: 20)),
          TextField(
            controller: secondUser,
          ),
          Text('Message', style: TextStyle(fontSize: 20)),
          TextField(
            controller: message,
          ),
          ElevatedButton(
              onPressed: () async {
                await hubConnection.invoke("ChatFromServer", args:<Object>[
                  firstUser.text,
                  secondUser.text,
                  message.text
                ]);
              },
              child:  Text("Send message")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          hubConnection.state == HubConnectionState.Disconnected ?
          await hubConnection.start()
              :
          await hubConnection.stop();

          setState(() {
            print(hubConnection.state == HubConnectionState.Disconnected  ? 'stop' : 'start');
          });
        },
        tooltip: 'Start/Stop',
        child: hubConnection.state == HubConnectionState.Disconnected ? Icon(Icons.play_arrow) : Icon(Icons.stop) ,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose((error) => print('Connection clos'));
    hubConnection.on("ReceiveNewMessage", handleNewMessage);
  }

  handleNewMessage(List<Object> args) {
    setState(() {
      print("Message is " + args[2]);
     // position = Offset(args[0], args[1]);
    });
  }
}
