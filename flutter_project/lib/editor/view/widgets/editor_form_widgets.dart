import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NivedahnamFormText extends StatefulWidget {
  const NivedahnamFormText({
    Key? key,
    required this.fieldName,
    this.numberField = false,
    this.dateField = false,
    this.categoryField = false,
    required this.keyName,
  }) : super(key: key);

  final String fieldName;
  final String keyName;
  final bool numberField;
  final bool dateField;
  final bool categoryField;

  @override
  _NivedahnamFormTextState createState() => _NivedahnamFormTextState();
}

class _NivedahnamFormTextState extends State<NivedahnamFormText> {
  late final TextEditingController _textEditingController;
  late EditorBloc _editorBloc;

  @override
  void initState() {
    super.initState();
    _editorBloc = context.read<EditorBloc>();
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.categoryField
        ? _editorBloc.state.editorFormMap.containsKey("categoryfields")
            ? _editorBloc.state.editorFormMap["categoryfields"]
                    [widget.keyName] ??
                ""
            : ""
        : _editorBloc.state.editorFormMap[widget.keyName] ?? "";
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
                          widget.categoryField
                              ? _editorBloc.add(FormEditedEvent({
                                  "categoryfields": {widget.keyName: value}
                                }))
                              : _editorBloc.add(
                                  FormEditedEvent({widget.keyName: value}));
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
                  widget.categoryField
                      ? _editorBloc.add(FormEditedEvent({
                          "categoryfields": {widget.keyName: text}
                        }))
                      : _editorBloc
                          .add(FormEditedEvent({widget.keyName: text}));
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
    value = _editorBloc.state.editorFormMap['reply_recieved'] == "true"
        ? true
        : false;
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
