import 'dart:convert';

import 'package:demo_app/constants.dart';
import 'package:http/http.dart' as http;

class GetAPI {
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

  static getApiWithoutToken(String uri) async {
    final response = await http.get(Uri.parse(setUrl(uri)));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch movie data');
    }
  }

  static getApi(String uri) async {
    return await http.get(Uri.parse(setUrl(uri)));
  }
}
