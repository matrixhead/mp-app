import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:mpapp/home/view/home_page_webview.dart';
import 'home_page_handsetview.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NivedhanamRepository nivedhanamRepository = NivedhanamRepository();
    return RepositoryProvider.value(
        value: nivedhanamRepository,
        child: BlocProvider(
          create: (context) => HomeBloc(nivedhanamRepository,
              RepositoryProvider.of<AuthenticationRepository>(context))
            ..add(NivedhanamFetchedEvent()),
          child: MediaQuery.of(context).size.width < 600
              ? HomePageHandsetView()
              : HomePageWebView(),
        ));
  }
}
