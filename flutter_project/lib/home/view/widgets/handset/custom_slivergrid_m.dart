import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';

class CustomSliverGridM extends StatelessWidget {
  const CustomSliverGridM(
    ScrollController scrollController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SliverGrid(
          delegate: gridItemBuilderM(state),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
          ),
        );
      },
    );
  }

  SliverChildBuilderDelegate gridItemBuilderM(HomeState state) {
    return SliverChildBuilderDelegate(
      (context, index) {
        return index >= state.nivedhanams.length
            ? BottomLoaderM()
            : CustomGridTileM(state.nivedhanams[index]);
      },
      childCount: state.hasReachedMax
          ? state.nivedhanams.length
          : state.nivedhanams.length + 1,
    );
  }
}

class CustomGridTileM extends StatelessWidget {
  const CustomGridTileM(
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

class BottomLoaderM extends StatelessWidget {
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
