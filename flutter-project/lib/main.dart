import 'package:flutter/material.dart';
import 'auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Login extends StatelessWidget {
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
                padding: const EdgeInsets.all(225.0),
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
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Enter Username ...'),
                      controller: text1,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Enter Password ...'),
                      obscureText: true,
                      controller: text2,
                    ),
                    SizedBox(height: 20),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () => {fetchToken(text1.text, text2.text)},
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: StadiumBorder(),
                            minimumSize: Size(double.infinity, 60),
                            primary: Colors.black),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
