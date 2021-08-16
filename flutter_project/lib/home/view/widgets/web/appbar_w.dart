import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/authentication/bloc/authentication_bloc.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSliverAppBarW extends StatelessWidget {
  const CustomSliverAppBarW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: Border(
        bottom:
            BorderSide(color: Colors.grey, width: .3, style: BorderStyle.solid),
      ),
      title: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "mpoKottayam",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'Bellota',
                ),
                textScaleFactor: 1.15,
              ),
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return SeachBox();
              },
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
                  Text(
                    toBeginningOfSentenceCase(context
                            .read<AuthenticationBloc>()
                            .state
                            .user
                            .userId) ??
                        "",
                    style: TextStyle(color: Colors.black),
                  ),
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

class SeachBox extends StatefulWidget {
  const SeachBox({
    Key? key,
  }) : super(key: key);

  @override
  _SeachBoxState createState() => _SeachBoxState();
}

class _SeachBoxState extends State<SeachBox> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = context.read<HomeBloc>().state.searchString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(SearchEditedEvent(_textEditingController.text));
                  },
                ),
              ),
              Expanded(
                child: BlocListener<HomeBloc, HomeState>(
                  listener: (context, state) {
                    _textEditingController.text = state.searchString;
                  },
                  child: TextField(
                    cursorColor: Colors.grey,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: 'Search eg: "letterno:11"'),
                    onSubmitted: (text) {
                      context.read<HomeBloc>().add(SearchEditedEvent(text));
                    },
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              if (_textEditingController.text.isNotEmpty) ...[
                IconButton(
                  color: Colors.grey,
                  splashColor: Colors.grey[600],
                  icon: Icon(Icons.cancel_rounded),
                  onPressed: () {
                    _textEditingController.text = "";
                    context
                        .read<HomeBloc>()
                        .add(SearchEditedEvent(_textEditingController.text));
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
