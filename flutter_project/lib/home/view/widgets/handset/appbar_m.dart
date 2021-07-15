import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/authentication/authentication.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';

class CustomSliverAppBarM extends StatefulWidget {
  const CustomSliverAppBarM({
    Key? key,
  }) : super(key: key);

  @override
  _CustomSliverAppBarMState createState() => _CustomSliverAppBarMState();
}

class _CustomSliverAppBarMState extends State<CustomSliverAppBarM> {
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = context.read<HomeBloc>().state.searchString;
    super.initState();
  }

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
                        hintText: "Search"),
                    onSubmitted: (text) {
                      context.read<HomeBloc>().add(SearchEditedEvent(text));
                    },
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black87,
                  ),
                  onPressed: () async {
                    final bool result = await showDialog(
                        context: context,
                        builder: (context) => ProfileM(
                            username: this
                                .context
                                .read<HomeBloc>()
                                .authenticationRepository
                                .getUser
                                .userId));
                    if (result) {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequested());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileM extends StatelessWidget {
  const ProfileM({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  Widget build(context) {
    return AlertDialog(
      content: Container(
        height: 350,
        width: 700,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              color: Colors.grey,
              size: 100,
            ),
            Text("signed in as"),
            Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Logut",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
              ),
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: .3, color: Colors.grey),
                  elevation: 1,
                  primary: Colors.white,
                  onPrimary: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
