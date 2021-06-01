import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(
    LoginUsernameChanged event,
    LoginState state,
  ) {
    return state.copyWith(
      username: event.username,
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    return state.copyWith(
      password: event.password,
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    yield state.copyWith(status: LoginStatus.submissionInProgress);
    try {
      await _authenticationRepository.logIn(
        username: state.username,
        password: state.password,
      );
      yield state.copyWith(status: LoginStatus.submissionSuccess);
    } on Exception catch (_) {
      yield state.copyWith(status: LoginStatus.submissionFailure);
    }
  }
}
