import 'package:flutter/material.dart';

class CustomSliverAppBarM extends StatelessWidget {
  const CustomSliverAppBarM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      floating: true,
      pinned: false,
      title: Material(
        elevation: 3,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
