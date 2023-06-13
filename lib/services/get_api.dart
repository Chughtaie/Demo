import 'dart:convert';
import 'package:demo_app/constants.dart';
import 'package:http/http.dart' as http;

class GetAPI {
  // Method to make an API request without a token
  getApiRequestWithoutToken(uri) async {
    String url = api + uri;

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  // Static method to make an API request without a token
  static getApiWithoutToken(String uri) async {
    try {
      final response = await http.get(Uri.parse(setUrl(uri)));

      if (response.statusCode == 200)
        print("response successful");
      else
        print('response unsuccessful');

      return json.decode(response.body);
    } catch (e) {
      print('Socket Exceptionm');
    }
  }

  // Static method to make an API request
  static getApi(String uri) async => await http.get(Uri.parse(setUrl(uri)));
}
