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
                ),
                value: '-SI_no',
              ),
              DropdownMenuItem(
                child: Text("oldest first"),
                value: 'SI_no',
              ),
              DropdownMenuItem(
                child: Text("category-asc "),
                value: 'Category',
              ),
              DropdownMenuItem(
                child: Text("category-dsc "),
                value: '-Category',
              ),
              DropdownMenuItem(
                child: Text("name-asc "),
                value: 'name',
              ),
              DropdownMenuItem(
                child: Text("name-dsc "),
                value: '-name',
              ),
              DropdownMenuItem(
                child: Text("address-asc "),
                value: 'address',
              ),
              DropdownMenuItem(
                child: Text("address-dsc "),
                value: '-address',
              ),
              DropdownMenuItem(
                child: Text("pincode-asc "),
                value: 'pincode',
              ),
              DropdownMenuItem(
                child: Text("pincode-dsc"),
                value: '-pincode',
              ),
              DropdownMenuItem(
                child: Text("letterno-asc"),
                value: 'letterno',
              ),
              DropdownMenuItem(
                child: Text("letterno-dsc"),
                value: '-letterno',
              ),
              DropdownMenuItem(
                child: Text("status-asc"),
                value: 'status',
              ),
              DropdownMenuItem(
                child: Text("status-dsc"),
                value: '-status',
              ),
            ]);
      },
    );
  }
}
