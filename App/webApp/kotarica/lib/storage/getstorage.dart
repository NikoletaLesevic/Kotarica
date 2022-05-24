import 'package:get_storage/get_storage.dart';

class GetStorageHelper {

  static final GetStorageHelper _singleton = GetStorageHelper._internal();

  factory GetStorageHelper() {
    return _singleton;
  }

  GetStorageHelper._internal();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void addUsername(String username) {
    GetStorage().write("username", username);
  }

  void addWallet(String wallet) {
    GetStorage().write("wallet", wallet);
  }

  String readWallet() {
    return GetStorage().read("wallet");
  }

  void addPassword(String password) {
    GetStorage().write("password", password);
  }

  String readUsername() {
    return GetStorage().read("username");
  }

  String readPassword() {
    return GetStorage().read("password");
  }

  void logout() {
    GetStorage().remove("username");
    GetStorage().remove("password");
    GetStorage().remove("wallet");
  }
}