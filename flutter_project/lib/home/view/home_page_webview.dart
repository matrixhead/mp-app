import 'package:flutter/material.dart';
import 'package:mpapp/home/view/widgets/web/custom_sliverlist_w.dart';
import 'widgets/web/fab_w.dart';
import 'widgets/web/home_widgets_w.dart';

class HomePageWebView extends StatefulWidget {
  const HomePageWebView({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageWebViewState createState() => _HomePageWebViewState();
}

class _HomePageWebViewState extends State<HomePageWebView> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(57.0), child: CustomSliverAppBarW()),
      floatingActionButton: Fab(),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            shape: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: .3, style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () => _pageController.previousPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn),
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () => _pageController.nextPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: CustomPageView(_pageController)),
        ],
      ),
    );
  }
}
