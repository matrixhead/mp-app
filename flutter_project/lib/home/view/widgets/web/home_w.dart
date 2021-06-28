import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'add_dialog.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Categories(),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 30),
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
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
              Text(
                category.categoryName,
                textScaleFactor: 1.1,
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
            ],
          ),
        ),
      ),
    );
  }
}
