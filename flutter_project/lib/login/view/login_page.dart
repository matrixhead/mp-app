import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/login/login.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication_repository.dart';
import 'package:mpapp/login/view/widgets/public.dart';

class Login extends StatelessWidget {
  final left = Left();

  final right = Expanded(
    child: Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signin",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.8,
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool useVerticalLayout = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: Row(children: [
          if (!useVerticalLayout) ...[left],
          right,
        ]),
      ),
    );
  }
}

class Left extends StatelessWidget {
  const Left({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome to Kottayam Mp office.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 2,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "If you want to know the status of your nivedhanam, click on the button below.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textScaleFactor: 1,
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context, builder: _publicDialog);
                    },
                    child: Text("Track nivedhanam"),
                    style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        shape: StadiumBorder(),
                        side: BorderSide(width: 1, color: Colors.white)),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget _publicDialog(BuildContext context) {
    return Public();
  }
}
