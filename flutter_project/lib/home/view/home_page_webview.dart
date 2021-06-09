import 'package:flutter/material.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:mpapp/home/view/widgets/web/custom_sliverlist_w.dart';
import 'widgets/web/home_widgets_w.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageWebView extends StatelessWidget {
  const HomePageWebView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/editor'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.create_sharp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Add nivedhanam",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                )
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: StadiumBorder(),
              primary: Colors.black,
              onPrimary: Colors.white),
        ),
      ),
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
        CustomSliverAppBarW(),
        CustomSliverListW(_scrollController),
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
