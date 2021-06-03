import 'package:flutter/material.dart';

class CustomSliverAppBarW extends StatelessWidget {
  const CustomSliverAppBarW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: Border(
        bottom:
            BorderSide(color: Colors.grey, width: .5, style: BorderStyle.solid),
      ),
      collapsedHeight: 150,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      title: Material(
        elevation: 3,
        child: Container(
          child: Row(
            children: [
              IconButton(
                splashColor: Colors.grey,
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: "Search..."),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(Icons.account_circle),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
