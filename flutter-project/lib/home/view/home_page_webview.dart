import 'package:flutter/material.dart';
import 'widgets/web/home_widgets_w.dart';

class HomePageWebView extends StatelessWidget {
  const HomePageWebView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrolViewW(),
    );
  }
}

class CustomScrolViewW extends StatefulWidget {
  const CustomScrolViewW({Key? key}) : super(key: key);

  @override
  _CustomScrolViewWState createState() => _CustomScrolViewWState();
}

class _CustomScrolViewWState extends State<CustomScrolViewW> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [CustomSliverAppBarW()],
    );
  }
}
