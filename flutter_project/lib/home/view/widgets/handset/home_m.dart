import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:mpapp/home/view/widgets/handset/add_dialog_m.dart';

import 'appbar_m.dart';

class HomeM extends StatelessWidget {
  const HomeM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomSliverAppBarM(),
        SliverList(
            delegate: SliverChildListDelegate(
                [RecentlyOpened(), OverViewM(), CategoryM()]))
      ],
    );
  }
}

class RecentlyOpened extends StatelessWidget {
  const RecentlyOpened({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              "Recently Opened",
              style: TextStyle(fontWeight: FontWeight.w600),
              textScaleFactor: 1.1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Divider(
            thickness: 1,
            height: 1,
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Container(
                height: 150,
                child: ListView.builder(
                  itemCount: state.recent.recentNivedhanams.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AbsorbPointer(
                      absorbing: state.status == NivedhanamStatus.initial,
                      child: RecentTile(
                          nivedhanam: state.recent.recentNivedhanams[index]),
                    );
                  },
                ));
          },
        ),
      ],
    );
  }
}

class RecentTile extends StatelessWidget {
  const RecentTile({Key? key, required this.nivedhanam}) : super(key: key);
  final Nivedhanam nivedhanam;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
    );
  }
}

class OverviewListtile extends StatelessWidget {
  const OverviewListtile(
      {Key? key, required this.fieldName, required this.keyName})
      : super(key: key);
  final String fieldName;
  final String keyName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              fieldName,
            ),
          ),
          Text(context.read<HomeBloc>().state.overview[keyName].toString())
        ],
      ),
    );
  }
}

class OverViewM extends StatelessWidget {
  const OverViewM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              "Overview",
              style: TextStyle(fontWeight: FontWeight.w600),
              textScaleFactor: 1.1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Divider(
            thickness: 1,
            height: 1,
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Container(
                height: 200,
                child: Column(
                  children: [
                    OverviewListtile(
                        fieldName: "Total number of nivedhanams",
                        keyName: "totalNivedhanams"),
                    OverviewListtile(
                        fieldName: "Nivedhanams being processed",
                        keyName: "processing"),
                    OverviewListtile(
                        fieldName: "Number of Approved nivedhanams",
                        keyName: "approved"),
                  ],
                ));
          },
        ),
      ],
    );
  }
}

class CategoryM extends StatelessWidget {
  const CategoryM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.w600),
                textScaleFactor: 1.1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await showDialog(context: context, builder: _addDialog);
                  if (result ?? false) {
                    context.read<HomeBloc>().add(CategoryFetchedEvent());
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(width: .7, color: Colors.grey),
                    elevation: 0.3,
                    primary: Colors.white,
                    onPrimary: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const Divider(
            thickness: 1,
            height: 1,
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Container(
                  child: ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryListTileM(state.categories[index]);
                      })),
            );
          },
        ),
      ],
    );
  }

  Widget _addDialog(BuildContext context) {
    return AddDialogM();
  }
}

class CategoryListTileM extends StatelessWidget {
  const CategoryListTileM(
    this.category, {
    Key? key,
  }) : super(key: key);
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: InkWell(
          onTap: () {
            context
                .read<HomeBloc>()
                .add(SearchEditedEvent("category:${category.categoryName}"));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.inventory_2_outlined),
              ),
              Expanded(
                child: Text(
                  category.categoryName,
                  textScaleFactor: 1.1,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
            ],
          ),
        ),
      ),
    );
  }
}
