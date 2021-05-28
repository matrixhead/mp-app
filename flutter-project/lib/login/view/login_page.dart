import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/login/login.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication_repository.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(color: Colors.black),
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to sdfsdf",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Omnis vero quo dolor quia. Et sint excepturi qui. Ex voluptatem quas sint suscipit eius inventore. Dolores et quo enim. Omnis accusantium autem qui architecto perspiciatis a. ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textScaleFactor: 1,
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => {},
                        child: Text("Know more"),
                        style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            shape: StadiumBorder(),
                            side: BorderSide(width: 1, color: Colors.white)),
                      )
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: const EdgeInsets.all(150.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Signin",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.8,
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                      LoginForm(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
