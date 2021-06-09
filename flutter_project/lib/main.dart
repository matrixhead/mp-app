import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication_repository.dart';
import 'app_view.dart';
import 'authentication/bloc/authentication_bloc.dart';
import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';

import 'data_layer/nivedhanam_repository/nivedhanam.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);
  final AuthenticationRepository authenticationRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: authenticationRepository,
          ),
          RepositoryProvider(create: (_) => NivedhanamRepository())
        ],
        child: BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
          ),
          child: AppView(),
        ));
  }
}
