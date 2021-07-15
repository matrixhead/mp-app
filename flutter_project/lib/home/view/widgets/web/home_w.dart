import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'add_dialog.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: RecentlyOpened(),
          ),
          Divider(),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Categories(),
                  const VerticalDivider(thickness: 1, width: 1),
                  Overview()
                ],
              ),
            ),
          ),
        ],
      ),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              "Recently Opened",
              textScaleFactor: 1.5,
            ),
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Expanded(
              child: Container(
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
              )),
            );
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
        padding: const EdgeInsets.all(30.0),
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
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            elevation: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      nivedhanam.name,
                      style: TextStyle(color: Colors.black),
                      textScaleFactor: 1.2,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      "Letter no:" + nivedhanam.letterno.toString(),
                      style: TextStyle(color: Colors.black),
                      textScaleFactor: .7,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      "Submitted on:" + nivedhanam.date,
                      style: TextStyle(color: Colors.black),
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
                      textScaleFactor: .7,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              width: 120,
              height: 165,
            ),
          ),
        ),
      ),
    );
  }
}

class Overview extends StatelessWidget {
  const Overview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                  child: Text(
                    "Overview",
                    textScaleFactor: 2,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return ListView(
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
                  );
                },
              ),
            )
          ],
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
      tileColor: Colors.white,
      shape: Border(
        bottom: BorderSide(
            color: Colors.black, width: .3, style: BorderStyle.solid),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              fieldName,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(context.read<HomeBloc>().state.overview[keyName].toString())
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                  child: Text(
                    "Categories",
                    textScaleFactor: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                          context: context, builder: _addDialog);
                      if (result ?? false) {
                        context.read<HomeBloc>().add(CategoryFetchedEvent());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: StadiumBorder(),
                        primary: Colors.white,
                        onPrimary: Colors.grey),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return GridView.builder(
                    itemCount: state.categories.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 19 / 9,
                        crossAxisCount: 4,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0),
                    itemBuilder: (context, i) {
                      return CategoryGridTile(state.categories[i]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addDialog(BuildContext context) {
    return AddDialog();
  }
}

class CategoryGridTile extends StatelessWidget {
  const CategoryGridTile(
    this.category, {
    Key? key,
  }) : super(key: key);
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20),
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
