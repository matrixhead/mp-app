import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.userId, this.token);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        token = json['token'];

  final String userId;
  final String token;

  static const empty = User('-', '-');

  @override
  List<Object> get props => [userId];
}
