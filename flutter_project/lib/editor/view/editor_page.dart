import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'widgets/editor_form_widgets.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? nivedhanam =
        (ModalRoute.of(context)!.settings.arguments as Nivedhanam?)?.toMap();
    return BlocProvider(
      create: (context) => EditorBloc(
          RepositoryProvider.of<NivedhanamRepository>(context),
          RepositoryProvider.of<AuthenticationRepository>(context),
          nivedhanam)
        ..add(FetchScannedImages(nivedhanam?["SI_no"]))
        ..add(CategoryFetchedEvent()),
      child: EditorPageWebView(),
    );
  }
}

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

class ScanView extends StatefulWidget {
  const ScanView({
    Key? key,
  }) : super(key: key);

  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  late EditorBloc _editBloc;
  late final PageController _pageController;

  @override
  void initState() {
    _editBloc = context.read<EditorBloc>();
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: BlocBuilder<EditorBloc, EditorState>(
        builder: (context, state) {
          return Stack(
            children: [
              PhotoViewGallery.builder(
                builder: (BuildContext context, int index) {
                  return state.scanloc == ScanLoc.local
                      ? PhotoViewGalleryPageOptions(
                          imageProvider: MemoryImage(
                              state.imageList.values.elementAt(index).bytes))
                      : PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(
                              state.imageList.values.elementAt(index)));
                },
                itemCount: state.imageList.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.cumulativeBytesLoaded,
                    ),
                  ),
                ),
                pageController: _pageController,
                scrollPhysics: NeverScrollableScrollPhysics(),
              ),
              Positioned(
                bottom: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowCompression: true,
                            allowMultiple: true,
                            type: FileType.image);

                    if (result != null) {
                      _editBloc.add(FilesSelectedEvent(result.files));
                    }
                  },
                  child: Icon(
                    Icons.post_add,
                    size: 25,
                    color: Colors.white.withOpacity(.8),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.grey.withOpacity(.4),
                    primary: Colors.transparent,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          );
        },
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.fieldName),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 350,
              ),
              child: DropdownButton<String>(
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
                  "Select Item Type",
                  style: TextStyle(color: Colors.grey),
                ),
                items: widget.choices
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
