import 'package:http/http.dart' as http;

class APIServices{
  static String url = "http://127.0.0.1:54317/api/Users";

  static Future fetchComponent() async {
    return await http.get(url);
  }
}