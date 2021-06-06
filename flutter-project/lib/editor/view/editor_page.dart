import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditorBloc(EditorState()),
      child: Scaffold(
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
      ),
    );
  }
}

class NivedhanamForm extends StatefulWidget {
  const NivedhanamForm({
    Key? key,
  }) : super(key: key);

  @override
  _NivedhanamFormState createState() => _NivedhanamFormState();
}

class _NivedhanamFormState extends State<NivedhanamForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> formValues = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              children: [
                NivedahnamFormText(
                  fieldName: "Name",
                ),
                NivedahnamFormText(fieldName: "Address"),
                NivedahnamFormText(
                    fieldName: "Letter number", numberField: true),
                NivedahnamFormText(fieldName: "Date", dateField: true),
                NivedahnamFormText(fieldName: "Reply recieved"),
                NivedahnamFormText(
                    fieldName: "Amount sanctioned", numberField: true),
                NivedahnamFormText(
                  fieldName: "Date sanctioned",
                  dateField: true,
                ),
                NivedahnamFormText(fieldName: "remarks"),
              ],
            ),
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

class NivedahnamFormText extends StatefulWidget {
  const NivedahnamFormText({
    Key? key,
    required this.fieldName,
    this.numberField = false,
    this.dateField = false,
  }) : super(key: key);

  final String fieldName;
  final bool numberField;
  final bool dateField;

  @override
  _NivedahnamFormTextState createState() => _NivedahnamFormTextState();
}

class _NivedahnamFormTextState extends State<NivedahnamFormText> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(widget.fieldName),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: TextFormField(
                readOnly: widget.dateField ? true : false,
                controller: _textEditingController,
                onTap: widget.dateField
                    ? () => _selectDate(context, _textEditingController)
                    : () {},
                keyboardType: widget.numberField ? TextInputType.number : null,
                inputFormatters: widget.numberField
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : null,
                minLines: 1,
                maxLines: 8,
              ),
            ),
          ),
        )
      ],
    );
  }

  _selectDate(
      BuildContext context, TextEditingController textEditingController) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    if (pickedDate != null) {
      final String formatted = formatter.format(pickedDate);
      textEditingController.text = formatted;
    }
  }
}
