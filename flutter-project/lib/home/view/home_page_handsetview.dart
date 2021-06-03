import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'widgets/handset/home_widgets_m.dart';

class HomePageHandsetView extends StatelessWidget {
  const HomePageHandsetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollViewM(),
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
        // SliverPersistentHeader(delegate: CustomFilter()),
        CustomSliverGrid(_scrollController)
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

class CustomSliverGrid extends StatelessWidget {
  const CustomSliverGrid(
    ScrollController scrollController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SliverGrid(
          delegate: gridItemBuilder(state),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
          ),
        );
      },
    );
  }

  SliverChildBuilderDelegate gridItemBuilder(HomeState state) {
    return SliverChildBuilderDelegate(
      (context, index) {
        return index >= state.nivedhanams.length
            ? BottomLoader()
            : CustomGridTile(state.nivedhanams[index]);
      },
      childCount: state.hasReachedMax
          ? state.nivedhanams.length
          : state.nivedhanams.length + 1,
    );
  }
}

class CustomGridTile extends StatelessWidget {
  const CustomGridTile(
    Nivedhanam nivedhanam, {
    Key? key,
  })  : nivedhanam = nivedhanam,
        super(key: key);
  final Nivedhanam nivedhanam;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Center(
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: .6, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.black),
            width: 160,
            height: 100,
          ),
        ),
      ),
      footer: GridTileBar(
        leading: Icon(
          Icons.description,
          color: Colors.grey,
        ),
        title: Text(
          nivedhanam.name,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          splashColor: Colors.grey,
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
