import 'dart:convert';
import 'dart:typed_data';
import 'package:mpapp/data_layer/exceptions.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'package:http_parser/http_parser.dart';

class NivedhanamRepository {
  final http.Client httpClient;

  NivedhanamRepository() : httpClient = http.Client();

  Future<List<Nivedhanam>> fetchNivedhanam(
      {required int postLimit,
      int startIndex = 0,
      required String token,
      required String searchquery,
      required String orderingquery}) async {
    Uri uri = Uri.http(
      url,
      '/api/nivedhanams/',
      <String, String>{
        'limit': '$postLimit',
        'offset': '$startIndex',
        'ordering': orderingquery
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
    if (response.reasonPhrase == "Unauthorized") throw AuthException();
    throw Exception();
  }

  Future<void> createNivedhanam(
      {required Map nivedhanamMap,
      required String token,
      required Uint8List? pdf}) async {
    Uri uri = Uri.http(url, '/api/nivedhanams/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response =
        await http.post(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode == 201) {
      if (pdf != null) {
        final siNo = jsonDecode(response.body)["SI_no"];
        uploadscans(pdf, token, siNo.toString());
      }
    } else {
      throw Exception(response);
    }
  }

  void updateNivedhanam(
      {required Map nivedhanamMap,
      required String token,
      required Uint8List? pdf}) async {
    String siNo = nivedhanamMap.remove("SI_no") ?? "";
    Uri uri = Uri.http(url, '/api/nivedhanams/$siNo/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    final response = await http.put(uri, body: nivedhanamMap, headers: headers);
    if (response.statusCode == 200) {
      if (pdf != null) {
        uploadscans(pdf, token, siNo);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<Uint8List> fetchscan(String? sino) async {
    Uri uri = Uri.http(
      url,
      '/api/scans/',
      <String, String>{
        'SI_no': '$sino',
      },
    );
    final response = await httpClient.get(uri);
    List scanurls = jsonDecode(response.body);
    String pdfUrl = "http://" + url + "/" + scanurls[0]["pdfurl"];
    final pdfresponse = await httpClient.get(Uri.parse(pdfUrl));

    return pdfresponse.bodyBytes;
  }

  void uploadscans(Uint8List pdf, String token, String siNo) async {
    Uri uri = Uri.http(url, '/api/scans/');
    Map<String, String> headers = {'Authorization': 'Token $token'};
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll({"SI_no": siNo});

    request.files.add(http.MultipartFile.fromBytes('scan', pdf,
        contentType: MediaType('application', 'pdf'), filename: "$siNo.pdf"));

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
      } else if (splittedFilter[0] == 'pincode') {
        queryMap.addAll({
          "pincode":
              splittedFilter.length > 1 ? splittedFilter.elementAt(1) : ""
        });
      } else if (splittedFilter[0] == 'address') {
        queryMap.addAll({
          "address":
              splittedFilter.length > 1 ? splittedFilter.elementAt(1) : ""
        });
      } else if (splittedFilter[0] == 'letterno') {
        queryMap.addAll({
          "letterno":
              splittedFilter.length > 1 ? splittedFilter.elementAt(1) : ""
        });
      } else if (splittedFilter[0] == 'mobile') {
        queryMap.addAll({
          "mobile": splittedFilter.length > 1 ? splittedFilter.elementAt(1) : ""
        });
      }
    });
    return queryMap;
  }

  Future<Map> fetchOverview(token) async {
    Map<String, String> headers = {'Authorization': 'Token $token'};
    Uri uri = Uri.http(url, '/api/nivedhanams/overview/');
    final response = await httpClient.get(uri, headers: headers);
    return jsonDecode(response.body);
  }

  Future<List<String>?> fetchSIfromSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('sino');
  }

  Future<Nivedhanam> fetchSingleNivedhanam(String sino, String token) async {
    Map<String, String> headers = {'Authorization': 'Token $token'};
    Uri uri = Uri.http(url, '/api/nivedhanams/$sino/');
    final response = await httpClient.get(uri, headers: headers);
    final res = jsonDecode(response.body);
    return Nivedhanam.fromJson(res);
  }

  void saveSIToSP(List<String> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("sino", list);
  }
}
