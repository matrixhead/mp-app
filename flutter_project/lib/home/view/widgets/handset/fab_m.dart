import 'package:flutter/material.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabM extends StatelessWidget {
  const FabM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.pushNamed(context, '/editor');
        if (result == true) {
          context.read<HomeBloc>().add(RefreshNivedhanamEvent());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          Icons.create_sharp,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
          elevation: 5,
          shape: CircleBorder(),
          primary: Colors.black,
          onPrimary: Colors.white),
    );
  }
}
