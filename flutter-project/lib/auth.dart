import 'package:http/http.dart' as http;
import 'dart:convert';

String url = "http://0.0.0.0:8000/api/get-token/";

void fetchToken(String username, password) async {
  Map<String, String> body = {"username": username, "password": password};
  final response = await http.post(Uri.parse(url), body: body);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    print(json["token"]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load ');
  }
}
