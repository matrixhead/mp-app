import 'dart:collection';
import 'dart:convert';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class NivedhanamRepository {
  final http.Client httpClient;

  NivedhanamRepository() : httpClient = http.Client();

  Future<List<Nivedhanam>> fetchNivedhanam(
      {required int postLimit,
      int startIndex = 0,
      required String token}) async {
    Uri uri = Uri.http(
      url,
      '/api/nivedhanams/',
      <String, String>{
        'limit': '$postLimit',
        'offset': '$startIndex',
      },
    );
    Map<String, String> headers = {'Authorization': 'Token $token'};

    final response = await httpClient.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      return resultMap['results']
          .map<Nivedhanam>((json) => Nivedhanam.fromJson(json))
          .toList();
    }
    throw Exception('error fetching posts');
  }

  Future<void> createNivedhanam(
      {required Map nivedhanamMap, required String token}) async {
    Uri uri = Uri.http(url, '/api/nivedhanams/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response =
        await http.post(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode != 201) {
      throw Exception(response);
    }
  }

  void updateNivedhanam(
      {required Map<String, String> nivedhanamMap,
      required String token}) async {
    String siNo = nivedhanamMap.remove("SI_no") ?? "";
    Uri uri = Uri.http(url, '/api/nivedhanams/$siNo/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response = await http.put(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode != 200) {
      throw Exception(response);
    }
  }

  Future<Map<int, String>> fetchscan(String? sino) async {
    Uri uri = Uri.http(
      url,
      '/api/scans/',
      <String, String>{
        'SI_no': '$sino',
      },
    );
    final response = await httpClient.get(uri);
    List scanurls = jsonDecode(response.body);
    SplayTreeMap<int, String> imageMap = SplayTreeMap();
    scanurls.forEach((element) async {
      String imageuri = "http://" + url + "/" + element["imageurl"];
      imageMap.addAll({element["id"]: imageuri});
    });
    return imageMap;
  }
}
