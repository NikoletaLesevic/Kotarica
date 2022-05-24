

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:kotarica/config/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:kotarica/auth/SignupPage.dart';

class UsersWallet {
  final String _rpcUrl=Config.RPC_URL;
  final String _wsUrl = Config.WS_URL;
  Web3Client client;
  // Wallet wallet;
  Credentials credentials;
  String username;
  Credentials unlocked;

  UsersWallet(String _username) {
    username = _username;
    client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/$username" + "Wallet.json");
  }

  writeWallet(String privateKey) async {
    final file = await _localFile;
    debugPrint("Wallet dobio key:" + privateKey);
    credentials = await client.credentialsFromPrivateKey(privateKey);
    Wallet wallet = Wallet.createNew(credentials, username, Random());
    // Write the file
    file.writeAsStringSync(wallet.toJson());
    print("Uspesno");
  }

  getAdress() async {
    File file = await _localFile;
    print(file.toString());
    String content = file.readAsStringSync();
    Wallet wallet = Wallet.fromJson(content, username);
    // print("PRIVATE " + wallet.privateKey.privateKey.toString());
    unlocked = wallet.privateKey;
    EthereumAddress adresa = await unlocked.extractAddress();
    print(adresa.toString());
    return adresa;
    // return unlocked;
  }

  getCredentialsfromUserName(userName) async
  {
    File file = await _localFile;
    print(file.toString());
    String content = file.readAsStringSync();
    Wallet wallet = Wallet.fromJson(content, userName);
    // print("PRIVATE " + wallet.privateKey.privateKey.toString());
    unlocked = wallet.privateKey;
    EthereumAddress adresa = await unlocked.extractAddress();
    print(adresa.toString());
    return credentials;
    // return unlocked;

  }

  getBalance(String publicKey)
  async {
    EthereumAddress adresa = EthereumAddress.fromHex(publicKey);
    EtherAmount balans = await client.getBalance(adresa);
    print(balans.getValueInUnit(EtherUnit.ether));

    //return balans.getValueInUnit(EtherUnit.ether);
  }

  transactEthers(String publicKey1, String publicKey2, EtherAmount amount) async
  {
      
   // EthereumAddress adresa = await unlocked.extractAddress();
    //print(adresa.toString());
    EthereumAddress sender = EthereumAddress.fromHex(publicKey1);
    EthereumAddress receiver = EthereumAddress.fromHex(publicKey2);
    
    
    {
      await client.sendTransaction(unlocked,
      Transaction(from: sender, 
                  to: receiver, 
                  value:amount,
                  gasPrice: EtherAmount.inWei(BigInt.one),
                  maxGas: 6721975, ));
        print("Izvrsena transakcija");
    }
    

  }

}