import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class API {
  Future<dynamic> fetch(String url, {Map<String, dynamic>? body}) async {
    try {
      final http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
