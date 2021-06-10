import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';

class CustomSliverListW extends StatelessWidget {
  const CustomSliverListW(
    ScrollController scrollController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SliverList(
          delegate: listItemBuilderW(state),
        );
      },
    );
  }

  SliverChildBuilderDelegate listItemBuilderW(HomeState state) {
    return SliverChildBuilderDelegate(
      (context, index) {
        return index >= state.nivedhanams.length
            ? BottomLoaderW()
            : CustomListTileW(state.nivedhanams[index]);
      },
      childCount: state.hasReachedMax
          ? state.nivedhanams.length
          : state.nivedhanams.length + 1,
    );
  }
}

class CustomListTileW extends StatelessWidget {
  const CustomListTileW(
    Nivedhanam nivedhanam, {
    Key? key,
  })  : nivedhanam = nivedhanam,
        super(key: key);
  final Nivedhanam nivedhanam;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final result = await Navigator.pushNamed(context, '/editor',
            arguments: nivedhanam);
        if (result == true) {
          context.read<HomeBloc>().add(RefreshNivedhanamEvent());
        }
      },
      leading: Icon(Icons.description),
      title: Text(nivedhanam.name),
    );
  }
}

class BottomLoaderW extends StatelessWidget {
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
