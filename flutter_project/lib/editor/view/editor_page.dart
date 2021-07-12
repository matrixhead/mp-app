import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'package:mpapp/editor/view/editor_page_handsetview.dart';
import 'editor_page_webview.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? nivedhanam =
        (ModalRoute.of(context)!.settings.arguments as Nivedhanam?)?.toMap();
    return BlocProvider(
        create: (context) => EditorBloc(
            RepositoryProvider.of<NivedhanamRepository>(context),
            RepositoryProvider.of<AuthenticationRepository>(context),
            nivedhanam)
          ..add(FetchScannedImages(nivedhanam?["SI_no"]))
          ..add(CategoryFetchedEvent()),
        child: MediaQuery.of(context).size.width < 600
            ? EditorPageHandsetView()
            : EditorPageWebView());
  }
}
