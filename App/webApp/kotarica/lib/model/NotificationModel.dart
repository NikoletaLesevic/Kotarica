import 'dart:convert';
import 'dart:math';
//import 'dart:html';
//import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:kotarica/config/config.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class NotificationListModel extends ChangeNotifier {
  List<Notificationn> notifications = [];
  List<KupovinaLogika> kupovine = [];
  List<Wallett> wallets = [];
  bool isLoading = true;

  final String _rpcUrl = Config.RPC_URL;
  final String _wsUrl = Config.WS_URL;
  final String _privateKey = Config.PRIVATE_KEY;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  int notifCount = 0;
  int kupovineCount = 0;
  int walletsCount = 0;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _countNotif;
  ContractFunction _countKupovine;
  ContractFunction _countWallets;
  ContractFunction _obavestenja;
  ContractFunction _kupovine;
  ContractFunction _wallets;
  ContractFunction _dodajObavestenje;
  ContractFunction _oznaciKaoProcitano;
  ContractFunction _kupiRezervisi;
  ContractFunction _prebaciRezervisanoUKupljeno;
  ContractFunction _createWallet;
  ContractFunction _prebaciUOcenjeno;
    ContractFunction _prebaciUKomentarisano;


  NotificationListModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentialls();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString("src/abis/NotificationList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"][Config.NETWORK_ID]["address"]);
    print(_contractAddress);
  }

  Future<void> getCredentialls() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();

    debugPrint(_ownAddress.toString());
    //debugPrint(_client.getBalance(_ownAddress).toString());
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "NotificationList"), _contractAddress);

    _countNotif = _contract.function("countNotif");
    _obavestenja = _contract.function("obavestenja");
    _dodajObavestenje = _contract.function("dodajObavestenje");
    _oznaciKaoProcitano = _contract.function("oznaciKaoProcitano");

    _countKupovine = _contract.function("countKupovine");
    _kupovine = _contract.function("kupovine");
    _kupiRezervisi = _contract.function("kupiRezervisi");
    _prebaciRezervisanoUKupljeno =
        _contract.function("prebaciRezervisanoUKupljeno");
     _prebaciUOcenjeno = _contract.function("prebaciUOcenjeno");   
     _prebaciUKomentarisano = _contract.function("prebaciUKomentarisano");

    _countWallets = _contract.function("countWallets");
    _wallets = _contract.function("wallets");
    _createWallet = _contract.function("createWallet");

    getObavestenja();
    getKupovine();
    getWallets();
  }

  getObavestenja() async {
    isLoading = true;
    List totalNotifList = await _client
        .call(contract: _contract, function: _countNotif, params: []);
    BigInt totalNotif = totalNotifList[0];
    notifCount = totalNotif.toInt();
    notifications.clear();

    for (var i = 0; i < notifCount; i++) {
      var temp = await _client.call(
          contract: _contract,
          function: _obavestenja,
          params: [BigInt.from(i)]);
      notifications.add(Notificationn(
          id: temp[0],
          naslov: temp[1],
          sadrzaj: temp[2],
          odKoga: temp[3],
          zaKoga: temp[4],
          datum: temp[5],
          kupljeno: temp[6],
          procitano: temp[7]));
    }

    for(var i=0;i<notifCount;i++)
    {
      debugPrint(notifications[i].naslov + " " + notifications[i].sadrzaj + " " + notifications[i].zaKoga + " " + notifications[i].odKoga + " " + notifications[i].procitano.toString() );
    }
    isLoading = false;
    notifyListeners();
  }

  getKupovine() async {
    List totalKupovineList = await _client
        .call(contract: _contract, function: _countKupovine, params: []);
    BigInt totalKupovine = totalKupovineList[0];
    kupovineCount = totalKupovine.toInt();
    kupovine.clear();

    for (var i = 0; i < kupovineCount; i++) {
      var temp = await _client.call(
          contract: _contract, function: _kupovine, params: [BigInt.from(i)]);
      kupovine.add(KupovinaLogika(
          id: temp[0],
          usernameKupac: temp[1],
          adOwner: temp[2],
          adName: temp[3],
          kupljeno: temp[4],
          datum: temp[5],
          ocenjeno: temp[6],
          komentarisano: temp[7]));
    }

    for(var i=0;i<kupovineCount;i++)
    debugPrint(kupovine[i].usernameKupac + " " + kupovine[i].adName + " " + kupovine[i].adOwner + " " + kupovine[i].ocenjeno.toString() + " " + kupovine[i].komentarisano.toString());

    notifyListeners();
  }

  getWallets() async {
    List totalWalletsList = await _client
        .call(contract: _contract, function: _countWallets, params: []);
    BigInt totalWallets = totalWalletsList[0];
    walletsCount = totalWallets.toInt();
    wallets.clear();

    for (var i = 0; i < walletsCount; i++) {
      var temp = await _client.call(
          contract: _contract, function: _wallets, params: [BigInt.from(i)]);
      wallets.add(
          Wallett(username: temp[0], imaWallet: temp[1], publicKey: temp[2]));
    }

    for(var i=0;i<walletsCount;i++)
    debugPrint(wallets[i].username + " " + wallets[i].publicKey);
    
    notifyListeners();
  }

  dodajObavestenje(String naslov, String sadrzaj, String odKoga, String zaKoga,
      String datum, BigInt kupljeno) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _dodajObavestenje,
          parameters: [naslov, sadrzaj, odKoga, zaKoga, datum, kupljeno],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));

   await getObavestenja();
  }

  oznaciKaoProcitano(BigInt id) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _oznaciKaoProcitano,
          parameters: [id],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    await  getObavestenja();
  }

  kupiRezervisi(String usernameKupac, String adOwner, String adName,
      BigInt kupljeno,String datum) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _kupiRezervisi,
          parameters: [usernameKupac, adOwner, adName, kupljeno,datum],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    await getKupovine();
  }

  prebaciRezervisanoUKupljeno(BigInt id) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _prebaciRezervisanoUKupljeno,
          parameters: [id],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    await getKupovine();
  }

  prebaciUOcenjeon(BigInt id) async
  {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _prebaciUOcenjeno,
          parameters: [id],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    await getKupovine();
  }

   prebaciUKomentarisano(BigInt id) async
  {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _prebaciUKomentarisano,
          parameters: [id],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    await getKupovine();
  } 



  createWallet(String username, bool ima, String publicKey) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _createWallet,
          parameters: [username, ima, publicKey],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    getWallets();
  }
}

class Notificationn {
  BigInt id;
  String naslov;
  String sadrzaj;
  String odKoga;
  String zaKoga;
  String
      datum; //ako je klik na kupi, danasnji datum, ako je rezervisi, ide odabrani datum za rezervaciju
  BigInt
      kupljeno; //0 rezervacija, 1 kupovina pouzecem, 2 kupovina kriptovalutom
  bool procitano;

  Notificationn(
      {this.id,
      this.naslov,
      this.sadrzaj,
      this.odKoga,
      this.zaKoga,
      this.datum,
      this.kupljeno,
      this.procitano});
}

class KupovinaLogika {
  BigInt id;
  String usernameKupac;
  String adOwner;
  String adName;
  BigInt kupljeno;
  String datum;
  bool ocenjeno;
  bool komentarisano;
  KupovinaLogika(
      {this.id, this.usernameKupac, this.adOwner, this.adName, this.kupljeno,this.datum,this.ocenjeno,this.komentarisano});
}

class Wallett {
  String username;
  bool imaWallet;
  String publicKey;
  Wallett({this.username, this.imaWallet, this.publicKey});
}
