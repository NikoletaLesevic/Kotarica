import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Prebacivanje novca'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
String rpcUrl = "http://192.168.43.28:7545";
String wsUrl = "ws://192.168.43.28:7545/";
Future<void> sendEther() async {
  Web3Client client = Web3Client(rpcUrl,Client(),socketConnector: (){
    return IOWebSocketChannel.connect(wsUrl).cast<String>();
  });

  
  String privateKey = "f4e35de0f97c06779c3ec85882aeabf3939d36eb9c7dc311e89870683d0cd9d7";
  Credentials credentials = await client.credentialsFromPrivateKey(privateKey);

  EthereumAddress recever = EthereumAddress.fromHex("0x61135eAeb6d6E87BFe7DCA2Af83df6736484dEcf");
  EthereumAddress ownAddress = await credentials.extractAddress();
  print(ownAddress);

  client.sendTransaction(credentials, Transaction(from: ownAddress, to: recever, value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 20)));
}

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pritisni dugme da prebacis novac:',
            ),
           
          ],
        ),
      ),backgroundColor: Colors.orangeAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: sendEther,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
