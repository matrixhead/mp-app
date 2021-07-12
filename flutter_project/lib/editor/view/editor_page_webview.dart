import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'widgets/web/editor_form_widgets.dart';
import 'widgets/web/scan_w.dart';

class EditorPageWebView extends StatelessWidget {
  const EditorPageWebView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<EditorBloc, EditorState>(
        listener: (context, state) {
          if (state.status == SubmissionStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Submission Failed')),
              );
          } else if (state.status == SubmissionStatus.submissionSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Submission Success')),
              );
          }
        },
        child: Row(
          children: [
            Expanded(flex: 3, child: ScanView()),
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
                            context.read<EditorBloc>().state.mode == Mode.create
                                ? "Add nivedhanam"
                                : "Update nivedhanam",
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
            child: BlocBuilder<EditorBloc, EditorState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    NivedahnamFormText(fieldName: "Name", keyName: "name"),
                    NivedahnamFormText(
                      fieldName: "Address",
                      keyName: 'address',
                    ),
                    NivedahnamFormText(
                      fieldName: "Pincode",
                      numberField: true,
                      keyName: 'pincode',
                    ),
                    NivedahnamFormText(
                      fieldName: "Mobile",
                      numberField: true,
                      keyName: 'mobile',
                    ),
                    NivedahnamFormText(
                      fieldName: "Letter number",
                      numberField: true,
                      keyName: 'letterno',
                    ),
                    NivedahnamFormText(
                        fieldName: "Date", dateField: true, keyName: 'date'),
                    DropDownField(
                      choices: ["recieved", "processing", "approved"],
                      fieldName: 'status',
                    ),
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
                    DropDownField(
                      choices:
                          state.categories.map((e) => e.categoryName).toList(),
                      fieldName: 'Category',
                    ),
                    if (state.editorFormMap['Category'] != null)
                      ...buildCategoryFields(state.editorFormMap['Category'])
                  ],
                );
              },
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
                              child: Text(
                                  context.read<EditorBloc>().state.mode ==
                                          Mode.create
                                      ? "Create"
                                      : "update",
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

  List<Widget> buildCategoryFields(String? categoryname) {
    final Category category = context
        .read<EditorBloc>()
        .state
        .categories
        .firstWhere((element) => element.categoryName == categoryname,
            orElse: () => Category("", {}));

    List<Widget> categoryFields = [];
    category.categoryFields.forEach((key, value) {
      if (value == 'Text') {
        categoryFields.add(NivedahnamFormText(
          fieldName: key,
          keyName: key,
          categoryField: true,
        ));
      } else if (value == 'Number') {
        categoryFields.add(NivedahnamFormText(
          fieldName: key,
          numberField: true,
          keyName: key,
          categoryField: true,
        ));
      } else if (value == 'Date') {
        categoryFields.add(NivedahnamFormText(
          fieldName: key,
          dateField: true,
          keyName: key,
          categoryField: true,
        ));
      }
    });
    return categoryFields;
  }
}
