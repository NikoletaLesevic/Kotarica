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

class AdListModel extends ChangeNotifier {
  List<Ad> ads = [];
  List<Ad> allAds = [];
  List<Wish> wishes = [];
  List<OcenaKorisnika> ocene = [];
  List<Slika> slike = [];
  bool isLoading = true;
  final String _rpcUrl=Config.RPC_URL;
  final String _wsUrl = Config.WS_URL;
  final String _privateKey = Config.PRIVATE_KEY;
  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  String _abiCodeWish;
  int adCount = 0;
  int allAdsCount = 0;
  int wishCount = 0;
  int oceneCount = 0;
  int slikeCount = 0;
  EthereumAddress _contractAddress;
  EthereumAddress _usersContractAdress;
  EthereumAddress _wishesContractAdress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _adCount;
  ContractFunction _ads;
  ContractFunction _createAd;
  ContractEvent _AdCreatedEvent;
  ContractFunction _wishes;
  ContractFunction _adWish;
  ContractFunction _wishCount;
  ContractFunction _removeWish;
  ContractFunction _oceneCount;
  ContractFunction _ocene;
  ContractFunction _dodeliOcenu;
  DeployedContract _contractWish;
  ContractFunction _removeAd;
  ContractFunction _addPic;
  ContractFunction _picCount;
  ContractFunction _slike;

  AdListModel() {
    initiateSetup();
    // getAbi();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getUsersContractAdress();
    await getWishContractAdress();
    await getCredentialls();
    await getDeployedContract();
    //await dodajProizvode();
    //await getPics();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString("src/abis/AdList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    String abiStringFileWish = await rootBundle.loadString("src/abis/WishList.json");
    var jsonAbiWish = jsonDecode(abiStringFileWish);
    _abiCodeWish = jsonEncode(jsonAbiWish["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"][Config.NETWORK_ID]["address"]);
    // print(_contractAddress);
  }

  Future<void> getUsersContractAdress() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/UserCrud.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _usersContractAdress =
        EthereumAddress.fromHex(jsonAbi["networks"][Config.NETWORK_ID]["address"]);
    print("USERS CONTRACT ADRESS " + _usersContractAdress.toString());
  }

  Future<void> getWishContractAdress() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/WishList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _wishesContractAdress =
        EthereumAddress.fromHex(jsonAbi["networks"][Config.NETWORK_ID]["address"]);

    print("Wishes CONTRACT ADRESS " + _wishesContractAdress.toString());
  }



  Future<void> getCredentialls() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();


    // debugPrint(_ownAddress.toString());
    //debugPrint(_client.getBalance(_ownAddress).toString());
  }


  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "AdList"), _contractAddress);

    _contractWish = DeployedContract(ContractAbi.fromJson(_abiCodeWish, "WishList"),_wishesContractAdress);


    _adCount = _contract.function("adCount");
    _createAd = _contract.function("createAd");
    _removeAd = _contract.function("removeAd");
    _ads = _contract.function("ads");
    _picCount = _contract.function("slikeCount");
    _slike = _contract.function("slike");
    _addPic = _contract.function("addPic");

    //_AdCreatedEvent = _contract.event("AdCreated");

    _adWish = _contractWish.function("addToWishList");
    _wishCount = _contractWish.function("wishCount");
    _wishes = _contractWish.function("wishes");
    _removeWish = _contractWish.function("removeFromWishList");

    _oceneCount = _contractWish.function("oceneCount");
    _dodeliOcenu = _contractWish.function("dodeliOcenu");
    _ocene = _contractWish.function("ocene");


    // print();
    print("UZIMAM PRVIH 10 oglasa");
    getAds();
    print("UZEO SAM OGLASA");
    getWishes();
    getOcene();
    getAllAds();
    getPics();
  }



  getAds() async {
    print("UZIMAM BROJ OGLASA");
    List totalAdsList =
    await _client.call(contract: _contract, function: _adCount, params: []);
    BigInt totalAds = totalAdsList[0];
    adCount = totalAds.toInt();
    ads.clear();
    int len = adCount - ads.length < 5 ? adCount - ads.length : 5;
    print("UZIMAM " + len.toString() + "OGLASA");

    for (var i = 0; i < len; i++) {
      var temp = await _client
          .call(contract: _contract, function: _ads, params: [BigInt.from(i)]);
      if(temp[0] != 'obrisan')    
      ads.add(Ad(
          name: temp[0],
          category: temp[1],
          description: temp[2],
          price: temp[3],
          contact: temp[4],
          user: temp[5],
          picHash: temp[6]));
      // ads.add(Ad(name: temp[0], category: temp[1], description: temp[2], price: temp[3]));
    }

    // for (var i = 0; i < totalAds.toInt(); i++) {
    //   // print(i);
    //   print(ads[i].picHash);
    // }
    isLoading = false;
    print("ZAVRSIO SA UZIMANJEM LOADING IS " + isLoading.toString());
    notifyListeners();
    // print(ads[0].name);
  }

  getAllAds() async {
    List totalAdsList =
    await _client.call(contract: _contract, function: _adCount, params: []);
    BigInt totalAds = totalAdsList[0];
    allAdsCount = totalAds.toInt();
    allAds.clear();

    for (var i = 0; i < allAdsCount; i++) {
      var temp = await _client
          .call(contract: _contract, function: _ads, params: [BigInt.from(i)]);
      if(temp[0] != 'obrisan')
      allAds.add(Ad(
          name: temp[0],
          category: temp[1],
          description: temp[2],
          price: temp[3],
          contact: temp[4],
          user: temp[5],
          picHash: temp[6]));
      // ads.add(Ad(name: temp[0], category: temp[1], description: temp[2], price: temp[3]));
    }

    // for (var i = 0; i < totalAds.toInt(); i++) {
    //   // print(i);
    //   print(ads[i].picHash);
    // }
    // isLoading = false;
    // notifyListeners();
    // print(ads[0].name);
  }


  addExists(String name, String user,int number)
  {
    for(var i=0; i< number;i++)
    {
      if(ads[i].name == name && ads[i].user == user)
        return true;
    }

    return false;
  }

  getAdsFromIndex() async {
    for(var i = ads.length; i<ads.length + 5 && i < adCount; i++) {
      var temp = await _client
          .call(contract: _contract, function: _ads, params: [BigInt.from(i)]);

      if(temp[0] != 'obrisan' && !addExists(temp[0], temp[5], ads.length))
      ads.add(Ad(
          name: temp[0],
          category: temp[1],
          description: temp[2],
          price: temp[3],
          contact: temp[4],
          user: temp[5],
          picHash: temp[6]));

      notifyListeners();
    }
  }

  getWishes() async {
    List totaWishesList = await _client
        .call(contract: _contractWish, function: _wishCount, params: []);
    BigInt totalWishes = totaWishesList[0];
    wishCount = totalWishes.toInt();
    wishes.clear();

    for (var i = 0; i < totalWishes.toInt(); i++) {
      var temp = await _client.call(
          contract: _contractWish, function: _wishes, params: [BigInt.from(i)]);
      wishes.add(Wish(
          username: temp[0],
          adOwner: temp[1],
          adName: temp[2],
          uListi: temp[3]));
    }

    for (var i = 0; i < wishCount; i++) {
      if (wishes[i] != null)
        debugPrint(wishes[i].username +
            " " +
            wishes[i].adName +
            " " +
            wishes[i].adOwner +
            wishes[i].uListi.toString());
      else
        debugPrint("Obrisano");
    }

    notifyListeners();
  }

  getOcene() async {
    List sveOceneList = await _client
        .call(contract: _contractWish, function: _oceneCount, params: []);
    BigInt sveOcene = sveOceneList[0];
    oceneCount = sveOcene.toInt();
    ocene.clear();

    for (var i = 0; i < sveOcene.toInt(); i++) {
      var temp = await _client.call(
          contract: _contractWish, function: _ocene, params: [BigInt.from(i)]);
      ocene.add(OcenaKorisnika(
          adName: temp[1],
          adOwner: temp[0],
          brojOcena: temp[2],
          zbirOcena: temp[3]));
    }

    for(var i=0;i<sveOcene.toInt();i++)
      debugPrint(ocene[i].adName + " " + ocene[i].adOwner + " " + ocene[i].zbirOcena.toString() + " " + ocene[i].brojOcena.toString());

    notifyListeners();
  }


  getPics() async {

    List sveSlikeList = await _client
        .call(contract: _contract, function: _picCount, params: []);
    BigInt sveSlike = sveSlikeList[0];
    slikeCount = sveSlike.toInt();
    slike.clear();

    for (var i = 0; i < sveSlike.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _slike, params: [BigInt.from(i)]);
      slike.add(Slika(
          adName: temp[0],
          adOwner: temp[1],
          hash: temp[2]));

    }
      notifyListeners();
  }



  addAd(String name, String category, String description, String price,
      String contact, String user, String picHash) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _createAd,
          parameters: [
            name,
            category,
            description,
            price,
            contact,
            user,
            picHash,
            _usersContractAdress
          ],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    // print("CREATE ADD");
    getAds();
    getAllAds();
    getAdsFromIndex();
  }


  addPic(String adName, String adOwner, String hash) async
  {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _addPic,
          parameters: [
            adName,
            adOwner,
            hash
          ],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
    // print("CREATE ADD");
    getPics();
  }

  removeAd(String adName, String adOwner) async
  {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _removeAd,
          parameters: [
            adName,
            adOwner,

          ],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));
   print("Remove ADD");
    await getAds();
    await getAllAds();
    await getAdsFromIndex();
  }

  addWish(String username, String adOwner, String adName) async {
    notifyListeners();
    bool postoji = false;

    if (username == adOwner) //ne sme svoj oglas da doda
      postoji = true;

    for (var i = 0;
    i < wishes.length;
    i++) //ako je u listi izbaci ga, ako nije, doda ga, tj menja samo true/false
      if (wishes[i].username == username &&
          wishes[i].adOwner == adOwner &&
          wishes[i].adName == adName) {
        postoji = true;
        // debugPrint("Izbacen iz liste");
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
              contract: _contractWish,
              function: _removeWish,
              parameters: [username, adOwner, adName],
              gasPrice: EtherAmount.inWei(BigInt.one),
              maxGas: 6721975,
            ));
      }

    if (!postoji)
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contractWish,
            function: _adWish,
            parameters: [username, adOwner, adName],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
          ));
    getWishes();
  }

  oceniOglas(String adName, String adOwner, BigInt ocena) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contractWish,
          function: _dodeliOcenu,
          parameters: [adName, adOwner, ocena],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
        ));

    getOcene();
  }

  izracunajProsecnuOcenu(String adName, String adOwner) {
    //getOcene();
    debugPrint(oceneCount.toString());
    for (var i = 0; i < oceneCount; i++) {
      if (ocene[i].adName == adName && ocene[i].adOwner == adOwner) {
        return (ocene[i].zbirOcena / ocene[i].brojOcena).toDouble();
      }
    }
  }

  returnPicHash(String username, String adName) {
    getAds();
    getAllAds();
    notifyListeners();
    for (var i = 0; i < adCount; i++) {
      if (ads[i].user == username && ads[i].name == adName)
        return ads[i].picHash;
    }
    return 'Slika nije dodeljena';
  }
}

class Ad {
  String name;
  String category;
  String description;
  String price;
  String contact;
  String user;
  String picHash;
  // Uint32 price;
  // BigInt price;

  // Ad({this.name, this.category, this.description, this.price});
  Ad(
      {this.name,
        this.category,
        this.description,
        this.price,
        this.contact,
        this.user,
        this.picHash});
}

class Wish {
  String username;
  String adOwner;
  String adName;
  bool uListi;

  Wish({this.username, this.adOwner, this.adName, this.uListi});
}

class OcenaKorisnika {
  String adName;
  String adOwner;
  BigInt brojOcena;
  BigInt zbirOcena;

  OcenaKorisnika({this.adName, this.adOwner, this.brojOcena, this.zbirOcena});
}

class Slika{ //za vise slika

  String adName;
  String adOwner;
  String hash;

  Slika({this.adName,this.adOwner,this.hash});
}