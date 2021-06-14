import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication/bloc/authentication_bloc.dart';
import 'data_layer/authentication_repository/authentication.dart';
import 'routes.dart';

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Open Sans",
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey, backgroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      routes: routes,
      initialRoute: "/",
      builder: (contex, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil('/login', (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
    );
  }
}
