import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:mpapp/home/view/widgets/handset/fab_m.dart';
import 'package:mpapp/home/view/widgets/handset/home_m.dart';
import 'widgets/handset/home_widgets_m.dart';

class HomePageHandsetView extends StatelessWidget {
  const HomePageHandsetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (current, next) {
        return current.navigationRailindex != next.navigationRailindex;
      },
      builder: (context, state) {
        return Scaffold(
            floatingActionButton: FabM(),
            body:
                state.navigationRailindex == 0 ? HomeM() : CustomScrollViewM(),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.description),
                    label: 'List',
                  ),
                ],
                currentIndex: state.navigationRailindex,
                selectedItemColor: Colors.black87,
                onTap: (index) {
                  context
                      .read<HomeBloc>()
                      .add(NavigationRailIndexChangedEvent(index));
                }));
      },
    );
  }
}

class CustomScrollViewM extends StatefulWidget {
  @override
  _CustomScrollViewMState createState() => _CustomScrollViewMState();
}

class _CustomScrollViewMState extends State<CustomScrollViewM> {
  final _scrollController = ScrollController();
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _homeBloc = context.read<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        CustomSliverAppBarM(),
        SliverPersistentHeader(delegate: CustomFilter()),
        CustomSliverGridM(_scrollController)
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _homeBloc.add(NivedhanamFetchedEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.7);
  }
}
