import 'dart:ui';

import 'package:flutter/material.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey,
              )),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: .1,
                          style: BorderStyle.solid),
                    )),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          "Add nivedhanam",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: NivedhanamForm()),
                ],
              ))
        ],
      ),
    );
  }
}

class NivedhanamForm extends StatelessWidget {
  const NivedhanamForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView(
            children: [
              NivedahnamFormText(fieldName: "Name"),
              NivedahnamFormText(fieldName: "Address"),
              NivedahnamFormText(fieldName: "Letter number"),
              NivedahnamFormText(fieldName: "Date"),
              NivedahnamFormText(fieldName: "Reply recieved"),
              NivedahnamFormText(fieldName: "Amount sanctioned"),
              NivedahnamFormText(fieldName: "Reply recieved"),
              NivedahnamFormText(fieldName: "Date sanctioned"),
              NivedahnamFormText(fieldName: "remarks"),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(width: .3, color: Colors.grey),
                      elevation: 1,
                      primary: Colors.white,
                      onPrimary: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Create",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: .3, color: Colors.grey),
                    elevation: 1,
                    primary: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NivedahnamFormText extends StatelessWidget {
  const NivedahnamFormText({
    Key? key,
    required this.fieldName,
  }) : super(key: key);

  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(fieldName),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: TextField(
                minLines: 1,
                maxLines: 8,
              ),
            ),
          ),
        )
      ],
    );
  }
}
