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
    return BlocProvider(
      create: (context) => HomeBloc(
          RepositoryProvider.of<NivedhanamRepository>(context),
          RepositoryProvider.of<AuthenticationRepository>(context))
        ..add(NivedhanamFetchedEvent())
        ..add(CategoryFetchedEvent())
        ..add(OverviewFetchedEvent())
        ..add(FetchSiFromSpEvent()),
      child: MediaQuery.of(context).size.width < 600
          ? HomePageHandsetView()
          : HomePageWebView(),
    );
  }
}
