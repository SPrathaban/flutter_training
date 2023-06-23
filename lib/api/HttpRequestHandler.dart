import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String backendUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:9085';

Future<http.Response> getApiRequest(url) async {
  return await http.get(convertUri(url));
}

Future<http.Response> postApiRequest(url, payload) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  payload = jsonEncode(payload);
  return await http.post(convertUri(url),
      body: payload, headers: requestHeaders);
}

Future<http.Response> deleteApiRequest(url) async {
  return await http.delete(convertUri(url));
}

var convertResponse = (response) {
  var responseObj = jsonDecode(utf8.decode(response.bodyBytes));
  return responseObj;
};

var convertUri = (url) {
  return Uri.http(backendUrl, url);
};
