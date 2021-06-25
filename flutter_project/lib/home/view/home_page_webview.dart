import 'package:flutter/material.dart';
import 'package:mpapp/home/view/widgets/web/custom_sliverlist_w.dart';
import 'widgets/web/fab_w.dart';
import 'widgets/web/home_w.dart';
import 'widgets/web/home_widgets_w.dart';

class HomePageWebView extends StatefulWidget {
  const HomePageWebView({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageWebViewState createState() => _HomePageWebViewState();
}

class _HomePageWebViewState extends State<HomePageWebView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(57.0), child: CustomSliverAppBarW()),
      floatingActionButton: Fab(),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description),
                label: Text(
                  'List',
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 0 ? Home() : List(),
          ),
        ],
      ),
    );
  }
}

class List extends StatefulWidget {
  const List({
    Key? key,
  }) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
