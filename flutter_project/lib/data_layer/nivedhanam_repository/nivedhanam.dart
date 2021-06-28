import 'dart:collection';
import 'dart:convert';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:http_parser/http_parser.dart';

class NivedhanamRepository {
  final http.Client httpClient;

  NivedhanamRepository() : httpClient = http.Client();

  Future<List<Nivedhanam>> fetchNivedhanam({
    required int postLimit,
    int startIndex = 0,
    required String token,
    required String searchquery,
  }) async {
    Uri uri = Uri.http(
      url,
      '/api/nivedhanams/',
      <String, String>{
        'limit': '$postLimit',
        'offset': '$startIndex',
      }..addAll(parseSearchquery(searchquery)),
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
      {required Map nivedhanamMap,
      required String token,
      required Map<int, dynamic> imageList}) async {
    Uri uri = Uri.http(url, '/api/nivedhanams/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response =
        await http.post(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode == 201) {
      final siNo = jsonDecode(response.body)["SI_no"];
      uploadscans(imageList, token, siNo.toString());
    } else {
      throw Exception(response);
    }
  }

  void updateNivedhanam(
      {required Map nivedhanamMap,
      required String token,
      required Map<int, dynamic> imageList}) async {
    String siNo = nivedhanamMap.remove("SI_no") ?? "";
    Uri uri = Uri.http(url, '/api/nivedhanams/$siNo/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response = await http.put(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode == 200) {
      if (imageList.isNotEmpty) {
        uploadscans(imageList, token, siNo);
      }
    } else {
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
      imageMap.addAll({element["page_number_read"]: imageuri});
    });
    return imageMap;
  }

  void uploadscans(
      Map<int, dynamic> imageList, String token, String siNo) async {
    Uri uri = Uri.http(url, '/api/scans/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll({"SI_no": siNo});

    imageList.forEach((key, value) {
      request.files
          .add(http.MultipartFile.fromString('page_number', key.toString()));

      request.files.add(http.MultipartFile.fromBytes('scan', value.bytes,
          contentType: MediaType('image', 'jpg'), filename: value.name));
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      throw Exception(response);
    }
  }

  Future<void> addCategory(String categoryName, Map categoryfields) async {
    Uri uri = Uri.http(url, '/api/category/');
    Map body = {"category_name": categoryName};
    Map cf2 = {};
    categoryfields.forEach((key, value) {
      cf2.addAll({value["name"]: value["type"]});
    });
    body.addAll({"categoryfields": jsonEncode(cf2)});
    final response = await http.post(uri, body: body);
    if (response.statusCode == 201) {
    } else {
      throw Exception(response);
    }
  }

  Future<List<Category>> fetchCategory() async {
    Uri uri = Uri.http(url, '/api/category/');
    final response = await httpClient.get(uri);
    if (response.statusCode == 200) {
      final resultMap = jsonDecode(response.body);
      return resultMap
          .map<Category>((json) => Category.fromJson(json))
          .toList();
    } else {
      throw Exception(response);
    }
  }

  Map<String, String> parseSearchquery(String searchquery) {
    Map<String, String> queryMap = {};
    final filterList = searchquery.split(";");
    filterList.forEach((element) {
      final splittedFilter = element.split(":");
      if (splittedFilter[0] == 'category') {
        queryMap.addAll({
          "Category":
              splittedFilter.length > 1 ? splittedFilter.elementAt(1) : ""
        });
      } else if (splittedFilter.length == 1) {
        queryMap.addAll({"name__icontains": splittedFilter[0]});
      }
    });
    return queryMap;
  }
}
