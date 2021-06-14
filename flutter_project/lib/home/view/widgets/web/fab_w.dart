import 'package:flutter/material.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Fab extends StatelessWidget {
  const Fab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/editor');
          if (result == true) {
            context.read<HomeBloc>().add(RefreshNivedhanamEvent());
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
                  Icons.create_sharp,
                  color: Colors.white,
                ),
              ),
              Text(
                "Add nivedhanam",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 16),
              )
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            shape: StadiumBorder(),
            primary: Colors.black,
            onPrimary: Colors.white),
      ),
    );
  }
}
