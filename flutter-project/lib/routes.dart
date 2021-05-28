import 'package:flutter/material.dart';
import 'package:mpapp/login/login.dart';
import 'package:mpapp/splash/view/splash_page.dart';

import 'home/home.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => SplashPage(),
  '/login': (context) => Login(),
  '/home': (context) => HomePage()
};
