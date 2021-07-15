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
    this.nullable = false,
  }) : super(key: key);
  final bool nullable;
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
        : _editorBloc.state.editorFormMap[widget.keyName] == "null" ||
                _editorBloc.state.editorFormMap[widget.keyName] == null
            ? ""
            : _editorBloc.state.editorFormMap[widget.keyName];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: TextFormField(
                validator: widget.nullable
                    ? (value) => null
                    : (value) {
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
                decoration: InputDecoration(
                  labelText: widget.fieldName,
                ),
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

class DropDownField extends StatefulWidget {
  const DropDownField({
    required this.choices,
    Key? key,
    required this.fieldName,
  }) : super(key: key);
  final List<String> choices;
  final String fieldName;

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String? dropdownValue;
  @override
  void initState() {
    dropdownValue =
        context.read<EditorBloc>().state.editorFormMap[widget.fieldName];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.fieldName,
              textScaleFactor: 0.9,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 350,
            ),
            child: DropdownButton<String>(
              underline: Container(
                height: 1.5,
                color: Colors.grey,
              ),
              isDense: false,
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.expand_more),
              iconSize: 24,
              elevation: 16,
              onChanged: (String? newValue) {
                context
                    .read<EditorBloc>()
                    .add(FormEditedEvent({widget.fieldName: newValue ?? ""}));
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              hint: Text(
                "Select ${widget.fieldName}",
                style: TextStyle(color: Colors.grey),
              ),
              items:
                  widget.choices.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
