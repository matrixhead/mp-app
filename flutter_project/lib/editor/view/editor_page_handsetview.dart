import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'package:mpapp/editor/view/widgets/handset/editor_form_widgets_m.dart';
import 'package:mpapp/editor/view/widgets/handset/scan_m.dart';
import 'widgets/handset/pdf_editor_m.dart';

class EditorPageHandsetView extends StatefulWidget {
  const EditorPageHandsetView({Key? key}) : super(key: key);

  @override
  _EditorPageHandsetViewState createState() => _EditorPageHandsetViewState();
}

class _EditorPageHandsetViewState extends State<EditorPageHandsetView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      iconTheme: IconThemeData(color: Colors.black87),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.post_add),
                            onPressed: () async {
                              final result = await showDialog(
                                  context: context, builder: _pdfEditor);
                              if (result != null) {
                                context
                                    .read<EditorBloc>()
                                    .add(FilesSelectedEvent(result));
                              }
                            },
                          )
                        ],
                      ),
                      collapsedHeight: 500,
                      expandedHeight: 500.0,
                      floating: false,
                      pinned: false,
                      snap: false,
                      flexibleSpace: ScanView(),
                    ),
                    BlocBuilder<EditorBloc, EditorState>(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: SliverList(
                              delegate: SliverChildListDelegate(
                            [
                              NivedahnamFormText(
                                fieldName: "Name",
                                keyName: "name",
                                disabled:
                                    state.mode == Mode.update ? true : false,
                              ),
                              NivedahnamFormText(
                                fieldName: "Address",
                                keyName: 'address',
                                nullable: true,
                              ),
                              NivedahnamFormText(
                                fieldName: "Pincode",
                                numberField: true,
                                keyName: 'pincode',
                                nullable: true,
                              ),
                              NivedahnamFormText(
                                fieldName: "Mobile",
                                numberField: true,
                                keyName: 'mobile',
                                nullable: true,
                              ),
                              NivedahnamFormText(
                                fieldName: "Letter number",
                                keyName: 'letterno',
                                disabled:
                                    state.mode == Mode.update ? true : false,
                              ),
                              NivedahnamFormText(
                                fieldName: "Date",
                                dateField: true,
                                keyName: 'date',
                                disabled:
                                    state.mode == Mode.update ? true : false,
                              ),
                              DropDownField(
                                choices: ["recieved", "processing", "approved"],
                                fieldName: 'status',
                              ),
                              NivedahnamFormText(
                                fieldName: "Amount sanctioned",
                                numberField: true,
                                keyName: 'amount_sanctioned',
                                nullable: true,
                              ),
                              NivedahnamFormText(
                                fieldName: "Date sanctioned",
                                dateField: true,
                                keyName: 'date_sanctioned',
                                nullable: true,
                              ),
                              NivedahnamFormText(
                                fieldName: "remarks",
                                keyName: 'remarks',
                                nullable: true,
                              ),
                              DropDownField(
                                choices: state.categories
                                    .map((e) => e.categoryName)
                                    .toList(),
                                fieldName: 'Category',
                              ),
                              if (state.editorFormMap['Category'] != null)
                                ...buildCategoryFields(
                                    state.editorFormMap['Category'])
                            ],
                          )),
                        );
                      },
                    )
                  ],
                ),
              ),
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
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
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
                        return state.status !=
                                SubmissionStatus.submissionInProgress
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
                                  side:
                                      BorderSide(width: .3, color: Colors.grey),
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
        ));
  }

  List<Widget> buildCategoryFields(String? categoryid) {
    final Category category = context
        .read<EditorBloc>()
        .state
        .categories
        .firstWhere(
            (element) => element.categoryId == int.parse(categoryid ?? "0"),
            orElse: () => Category("", {}, 0));

    List<Widget> categoryFields = [];
    category.categoryFields.forEach((key, value) {
      if (value == 'Text') {
        categoryFields.add(NivedahnamFormText(
          key: ValueKey(key),
          fieldName: key,
          keyName: key,
          categoryField: true,
          nullable: true,
        ));
      } else if (value == 'Number') {
        categoryFields.add(NivedahnamFormText(
          key: ValueKey(key),
          fieldName: key,
          numberField: true,
          keyName: key,
          categoryField: true,
          nullable: true,
        ));
      } else if (value == 'Date') {
        categoryFields.add(NivedahnamFormText(
          key: ValueKey(key),
          fieldName: key,
          dateField: true,
          keyName: key,
          categoryField: true,
          nullable: true,
        ));
      }
    });
    return categoryFields;
  }

  Widget _pdfEditor(BuildContext context) {
    return PdfEditorM();
  }
}
