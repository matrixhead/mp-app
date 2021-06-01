import 'package:flutter/material.dart';

class CustomFilter extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(height: constraints.maxHeight, child: Text(""));
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => false;

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 20;
}
