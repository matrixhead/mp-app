import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/public/cubit/public_cubit.dart';
import 'package:mpapp/public/view/public_page_webview.dart';

class PublicPage extends StatelessWidget {
  const PublicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PublicCubit(), child: PublicPageWebView());
  }
}
