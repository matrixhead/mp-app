part of 'login_bloc.dart';

enum LoginStatus {
  pure,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class LoginState extends Equatable {
  const LoginState(
      {this.username = "", this.password = "", this.status = LoginStatus.pure});

  final String username;
  final String password;
  final LoginStatus status;

  @override
  List<Object> get props => [username, password, status];
  LoginState copyWith({
    String? username,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  bool get isSubmissionInProgress =>
      this.status == LoginStatus.submissionInProgress;
}
