import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              childAspectRatio: 16 / 12.5),
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
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 8),
        child: Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () async {
              context.read<HomeBloc>().add(AddNivedhanamToRecent(nivedhanam));
              final result = await Navigator.pushNamed(context, '/editor',
                  arguments: nivedhanam);
              if (result == true) {
                context.read<HomeBloc>().add(RefreshNivedhanamEvent());
              }
            },
            child: Material(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              elevation: 2,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        "Letter no:" + nivedhanam.letterno.toString(),
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        "Submitted on:" + nivedhanam.date,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        textScaleFactor: .7,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        "Status:" + nivedhanam.status,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        textScaleFactor: .7,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                width: 170,
                height: 100,
              ),
            ),
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: GridTileBar(
          leading: Icon(
            Icons.description,
            color: Colors.grey,
          ),
          title: Text(
            toBeginningOfSentenceCase(nivedhanam.name) ?? "",
            style: TextStyle(color: Colors.black87),
          ),
          trailing: IconButton(
            splashColor: Colors.black87,
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
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
