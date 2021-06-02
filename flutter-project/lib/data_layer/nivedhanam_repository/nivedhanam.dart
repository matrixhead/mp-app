import 'dart:convert';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class NivedhanamRepository {
  final http.Client httpClient;

  NivedhanamRepository() : httpClient = http.Client();

  Future<List<Nivedhanam>> fetchNivedhanam(
      {required int postLimit, int startIndex = 0}) async {
    Uri uri = Uri.parse(url +
        'api/nivedhanams/?limit=' +
        postLimit.toString() +
        '&offset=' +
        startIndex.toString());

    final response = await httpClient.get(uri);
    Map<String, dynamic> resultMap = jsonDecode(response.body);
    return resultMap['results']
        .map<Nivedhanam>((json) => Nivedhanam.fromJson(json))
        .toList();
  }
}
