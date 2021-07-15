import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';

class CustomFilter extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: SortButton(),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => false;

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;
}

class SortButton extends StatefulWidget {
  const SortButton({Key? key}) : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return DropdownButton<String>(
            underline: Container(),
            isDense: true,
            isExpanded: false,
            icon: Icon(
              Icons.unfold_more,
              color: Colors.grey,
            ),
            value: state.orderingString,
            iconSize: 20,
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
                  style: TextStyle(color: Colors.grey),
                ),
                value: '-SI_no',
              ),
              DropdownMenuItem(
                child: Text(
                  "oldest first",
                  style: TextStyle(color: Colors.grey),
                ),
                value: 'SI_no',
              )
            ]);
      },
    );
  }
}
