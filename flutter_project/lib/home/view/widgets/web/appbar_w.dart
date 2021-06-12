import 'package:flutter/material.dart';
import 'package:mpapp/authentication/bloc/authentication_bloc.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSliverAppBarW extends StatelessWidget {
  const CustomSliverAppBarW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: Border(
        bottom:
            BorderSide(color: Colors.grey, width: .3, style: BorderStyle.solid),
      ),
      collapsedHeight: 57,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      title: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.grey[800],
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "mpoKottayam",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Material(
                  color: Colors.grey[200],
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          color: Colors.grey,
                          splashColor: Colors.grey[600],
                          icon: Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              hintText: "Search"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      color: Colors.grey[800],
                      icon: Icon(Icons.replay_outlined),
                      onPressed: () {
                        context.read<HomeBloc>().add(RefreshNivedhanamEvent());
                      },
                    ),
                  ),
                  Text(context.read<AuthenticationBloc>().state.user.userId),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      color: Colors.grey[800],
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutRequested());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
