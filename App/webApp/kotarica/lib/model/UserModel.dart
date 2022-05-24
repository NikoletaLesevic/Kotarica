import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:kotarica/config/config.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class UserModel extends ChangeNotifier {
  List<User> users = [];
  List<UserPic> pics = [];
  bool isLoading = false;
  int userCount = 0;
  int picsCount = 0;
  final String _rpcUrl=Config.RPC_URL;
  final String _wsUrl = Config.WS_URL;
  final String privateKey = Config.PRIVATE_KEY;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  Credentials _credentials;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _nextId;
  ContractFunction _create;
  ContractFunction _updateUser;
  ContractFunction _checkUser;
  ContractEvent _pronadjenKorisnik;
  ContractFunction _korisnici;
  ContractFunction _pics;
  ContractFunction _picCount;
  ContractFunction _addPic;

  UserModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/UserCrud.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"][Config.NETWORK_ID]["address"]);
    debugPrint((_contractAddress).toString());
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "UserCrud"), _contractAddress);

    _nextId = _contract.function("nextId");
    _create = _contract.function("create");
    _checkUser = _contract.function("checkUser");
    _pronadjenKorisnik = _contract.event("postojeciKorisnik");
    _korisnici = _contract.function("korisnici");
    _updateUser = _contract.function("updateUser");
    _pics = _contract.function("pics");
    _addPic = _contract.function("addPic");
    _picCount = _contract.function("picCount");
    getUsers();
    getPics();
    // print("");

    debugPrint(
        (await _client.call(contract: _contract, function: _nextId, params: []))
            .toString());
  }

  getUsers() async {
    List allUsers =
        await _client.call(contract: _contract, function: _nextId, params: []);
    BigInt brUsera = allUsers[0];
    //debugPrint(brUsera.toString());
    users.clear();
    userCount=0;
  isLoading=true;
    debugPrint(users.length.toString());
    for (var i = 0; i < brUsera.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _korisnici, params: [BigInt.from(i)]);
      users.add(User(
          userName: temp[1],
          password: temp[2].toString(),
          firstName: temp[3],
          lastName: temp[4],
          mail: temp[5],
          mobile: temp[6],
          adresa: temp[7]));
      userCount++;
    }

   /* for (var i = 0; i < brUsera.toInt(); i++)
      debugPrint(users[i].userName +
          " " +
          users[i].password +
          " " +
          users[i].firstName +
          " " +
          users[i].lastName +
          " " +
          users[i].adresa);*/
    isLoading = false;
    notifyListeners();
  }

  getPics() async {
    List allPicsList = await _client
        .call(contract: _contract, function: _picCount, params: []);
    if(allPicsList==null) debugPrint("allPicsList je NULL !");
    BigInt allPics = allPicsList[0];
    picsCount = allPics.toInt();
    pics.clear();

    for (var i = 0; i < picsCount; i++) {
      var temp = await _client
          .call(contract: _contract, function: _pics, params: [BigInt.from(i)]);
      pics.add(UserPic(username: temp[0], picHash: temp[1]));
    }

    notifyListeners();
  }

  addUser(String userName, String password, String firstName, String lastName,
      String mail, String mobile, String adresa) async {
    //isLoading = true;

    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _create,
            parameters: [
              userName,
              password,
              firstName,
              lastName,
              mail,
              mobile,
              adresa
            ],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975));

    //debugPrint(userName.toString());
    //debugPrint(userCount.toString());
    debugPrint(
        (await _client.call(contract: _contract, function: _nextId, params: []))
            .toString());
     getUsers();
    //checkUserZaRegistraciju(userName);
  }

  checkUserZaLogin(String userName, String password) async {
    notifyListeners();
    /*for (var i = 0; i < users.length; i++) {
      if (users[i].userName == userName && users[i].password == password) {
        debugPrint("POSTOJI");
        return ("POSTOJI");
      }
    }
    return ("NE POSTOJI");*/
    String odg;
    void odgovor = await _client.call(
        contract: _contract,
        function: _checkUser,
        params: [userName, password]).then((value) {
      odg = value[0].toString();
      debugPrint(odg);
    });
    return odg;
  }

  checkUserZaRegistraciju(String userName) {
    notifyListeners();
    for (var i = 0; i < users.length; i++) {
      if (users[i].userName == userName) {
        debugPrint("POSTOJI USERNAME");
        return ("POSTOJI");
      }
    }

    return ("NE POSTOJI");
  }

  updateUser(String username, String password, String firstName,
      String lastName, String mobile, String email, String address) async {
    notifyListeners();
    if (username != null) {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _updateUser,
              parameters: [
                username,
                password,
                firstName,
                lastName,
                mobile,
                email,
                address
              ],
              gasPrice: EtherAmount.inWei(BigInt.one),
              maxGas: 6721975));
    }

    await getUsers();
  }

  returnPicHash(String username) async {
    await getPics();
    //notifyListeners();
    if(pics==null) debugPrint("Pics je NULL !");
    for (var i = 0; i < pics.length; i++) { // zamenjeno picsCount sa pics.length
      if (pics[i].username == username) return pics[i].picHash;
    }
    return "Nije dodeljena slika";
  }

  addPic(String username, String hash) async {
    //notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addPic,
            parameters: [username, hash],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975));
    getPics();
  }

  // addPrivateKey(String key) {
  //   this.privateKey = key;
  // }
}

class User {
  //int id;
  String userName;
  String password;
  String firstName;
  String lastName;
  String mail;
  String mobile;
  String adresa;
  UserPic picture;
  bool isOnline;

  User(
      {this.userName,
      this.password,
      this.firstName,
      this.lastName,
      this.mail,
      this.mobile,
      this.adresa});

  User.m(
      {this.userName,
      this.firstName,
      this.lastName,
      this.picture,
      this.isOnline});
}

class UserPic {
  String username;
  String picHash;

  UserPic({this.username, this.picHash});
}

final User currentUser = User.m(
    userName: 'peraperica',
    firstName: 'Pera',
    lastName: 'Petrovic',
    isOnline: true);
final User user1 = User.m(
    userName: 'mikamikic',
    firstName: 'Mika',
    lastName: 'Mikic',
    isOnline: true);
final User user2 = User.m(
    userName: 'ivan123',
    firstName: 'Ivan',
    lastName: 'Ivanovic',
    isOnline: false);
final User user3 = User.m(
    userName: 'vladan55',
    firstName: 'Vladan',
    lastName: 'Radenkovic',
    isOnline: true);
final User user4 = User.m(
    userName: 'nenad22',
    firstName: 'Nenad',
    lastName: 'Petrovic',
    isOnline: false);
final User user5 = User.m(
    userName: 'darko00',
    firstName: 'Darko',
    lastName: 'Stefanovic',
    isOnline: true);
