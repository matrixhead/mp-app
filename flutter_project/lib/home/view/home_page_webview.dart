import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
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
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (current, next) {
          return current.navigationRailindex != next.navigationRailindex;
        },
        builder: (context, state) {
          return Row(
            children: [
              NavigationRail(
                selectedIndex: state.navigationRailindex,
                onDestinationSelected: (int index) {
                  context
                      .read<HomeBloc>()
                      .add(NavigationRailIndexChangedEvent(index));
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
                child: state.navigationRailindex == 0 ? Home() : List(),
              ),
            ],
          );
        },
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
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
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
                SortButton()
              ],
            ),
          ),
        ),
        Expanded(child: CustomPageView(_pageController)),
      ],
    );
  }
}

// class Pagenumber extends StatefulWidget {
//   const Pagenumber(this.pageController, {Key? key}) : super(key: key);
//   final PageController pageController;
//   @override
//   _PagenumberState createState() => _PagenumberState();
// }

// class _PagenumberState extends State<Pagenumber> {
//   double? currentPage;
//   @override
//   void initState() {
//     widget.pageController.addListener(() {
//       if (widget.pageController.hasClients) {
//         currentPage = widget.pageController.page;
//       }
//       setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         return Visibility(
//           visible: state.searchString == "",
//           child: Text(currentPage.toString()),
//         );
//       },
//     );
//   }
// }

class SortButton extends StatefulWidget {
  const SortButton({Key? key}) : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 25,
            width: 120,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return DropdownButton<String>(
                    underline: Container(),
                    isDense: true,
                    isExpanded: true,
                    icon: Icon(
                      Icons.ac_unit,
                      color: Colors.transparent,
                    ),
                    value: state.orderingString,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      context
                          .read<HomeBloc>()
                          .add(OrderingChanged(newValue ?? "-SI_no"));

                      setState(() {});
                    },
                    hint: Text(
                      "Select ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "newest first",
                        ),
                        value: '-SI_no',
                      ),
                      DropdownMenuItem(
                        child: Text("oldest first"),
                        value: 'SI_no',
                      ),
                      DropdownMenuItem(
                        child: Text("category-asc "),
                        value: 'Category',
                      ),
                      DropdownMenuItem(
                        child: Text("category-dsc "),
                        value: '-Category',
                      ),
                      DropdownMenuItem(
                        child: Text("name-asc "),
                        value: 'name',
                      ),
                      DropdownMenuItem(
                        child: Text("name-dsc "),
                        value: '-name',
                      ),
                      DropdownMenuItem(
                        child: Text("address-asc "),
                        value: 'address',
                      ),
                      DropdownMenuItem(
                        child: Text("address-dsc "),
                        value: '-address',
                      ),
                      DropdownMenuItem(
                        child: Text("pincode-asc "),
                        value: 'pincode',
                      ),
                      DropdownMenuItem(
                        child: Text("pincode-dsc"),
                        value: '-pincode',
                      ),
                      DropdownMenuItem(
                        child: Text("letterno-asc"),
                        value: 'letterno',
                      ),
                      DropdownMenuItem(
                        child: Text("letterno-dsc"),
                        value: '-letterno',
                      ),
                      DropdownMenuItem(
                        child: Text("status-asc"),
                        value: 'status',
                      ),
                      DropdownMenuItem(
                        child: Text("status-dsc"),
                        value: '-status',
                      ),
                    ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
