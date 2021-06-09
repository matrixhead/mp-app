import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditorBloc(
        RepositoryProvider.of<NivedhanamRepository>(context),
        RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: Scaffold(
        body: BlocListener<EditorBloc, EditorState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.submissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Submission Failed')),
                );
            } else if (state.status == SubmissionStatus.submissionSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Submission Success')),
                );
            }
          },
          child: Row(
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
                NivedahnamFormText(fieldName: "Name", keyName: "name"),
                NivedahnamFormText(
                  fieldName: "Address",
                  keyName: 'address',
                ),
                NivedahnamFormText(
                  fieldName: "Letter number",
                  numberField: true,
                  keyName: 'letterno',
                ),
                NivedahnamFormText(
                    fieldName: "Date", dateField: true, keyName: 'date'),
                NivedhanamFormRadio(
                    fieldName: "Reply recieved", keyName: 'reply_recieved'),
                NivedahnamFormText(
                  fieldName: "Amount sanctioned",
                  numberField: true,
                  keyName: 'amount_sanctioned',
                ),
                NivedahnamFormText(
                  fieldName: "Date sanctioned",
                  dateField: true,
                  keyName: 'date_sanctioned',
                ),
                NivedahnamFormText(
                  fieldName: "remarks",
                  keyName: 'remarks',
                ),
              ],
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    return state.status != SubmissionStatus.submissionInProgress
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<EditorBloc>()
                                    .add(FormSubmittedEvent());
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Create",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(width: .3, color: Colors.grey),
                              elevation: 1,
                              primary: Colors.black,
                            ),
                          )
                        : CircularProgressIndicator();
                  },
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
    required this.keyName,
  }) : super(key: key);

  final String fieldName;
  final String keyName;
  final bool numberField;
  final bool dateField;

  @override
  _NivedahnamFormTextState createState() => _NivedahnamFormTextState();
}

class _NivedahnamFormTextState extends State<NivedahnamFormText> {
  final TextEditingController _textEditingController = TextEditingController();
  late EditorBloc _editorBloc;

  @override
  void initState() {
    super.initState();
    _editorBloc = context.read<EditorBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.fieldName),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ' + widget.fieldName;
                  }
                  return null;
                },
                readOnly: widget.dateField ? true : false,
                controller: _textEditingController,
                onTap: widget.dateField
                    ? () {
                        _selectDate(context).then((value) {
                          _textEditingController.text = value;
                          _editorBloc
                              .add(FormEditedEvent({widget.keyName: value}));
                        });
                      }
                    : () {},
                keyboardType: widget.numberField ? TextInputType.number : null,
                inputFormatters: widget.numberField
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : null,
                minLines: 1,
                maxLines: 8,
                onChanged: (text) {
                  _editorBloc.add(FormEditedEvent({widget.keyName: text}));
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<String> _selectDate(
    BuildContext context,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (pickedDate != null) {
      final String formatted = formatter.format(pickedDate);
      return formatted;
    }
    return "";
  }
}

class NivedhanamFormRadio extends StatefulWidget {
  const NivedhanamFormRadio(
      {Key? key, required this.fieldName, required this.keyName})
      : super(key: key);
  final String fieldName;
  final String keyName;

  @override
  _NivedhanamFormRadioState createState() => _NivedhanamFormRadioState();
}

class _NivedhanamFormRadioState extends State<NivedhanamFormRadio> {
  bool? value = false;
  late EditorBloc _editorBloc;
  @override
  void initState() {
    super.initState();
    _editorBloc = context.read<EditorBloc>();
    _editorBloc.add(FormEditedEvent({widget.keyName: value.toString()}));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.fieldName),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.grey.shade400),
                )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                            value: true,
                            groupValue: value,
                            onChanged: (bool? _) {
                              _editorBloc.add(FormEditedEvent(
                                  {widget.keyName: _.toString()}));
                              setState(() {
                                value = _;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('No'),
                        leading: Radio(
                            value: false,
                            groupValue: value,
                            onChanged: (bool? _) {
                              _editorBloc.add(FormEditedEvent(
                                  {widget.keyName: _.toString()}));
                              setState(() {
                                value = _;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
