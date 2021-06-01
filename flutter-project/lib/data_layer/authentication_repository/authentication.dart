import 'dart:async';
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
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    Map<String, String> body = {"username": username, "password": password};
    final response = await http.post(Uri.parse(url + "get-token/"), body: body);
    Map<String, dynamic> userMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _user = User.fromJson(userMap);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw Exception(userMap['non_field_errors']);
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
