import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/models.dart';
import 'package:mpapp/data_layer/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  User _user = User.empty;

  User get getUser => _user;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    yield await getUserSP()
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    Uri uri = Uri.http(url, "/get-token/");
    Map<String, String> body = {"username": username, "password": password};
    final response = await http.post(uri, body: body);
    Map<String, dynamic> userMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _user = User.fromJson(userMap);
      saveUserSP();
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw Exception(userMap['non_field_errors']);
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  void saveUserSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("user", [_user.userId, _user.token]);
  }

  Future<bool> getUserSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> user = prefs.getStringList('user') ?? [];
    if (user.isEmpty) {
      return false;
    }
    _user = User(user[0], user[1]);
    return true;
  }
}
