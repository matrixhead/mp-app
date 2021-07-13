import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/editor/cubit/pdf_cubit.dart';

class PdfEditorM extends StatelessWidget {
  const PdfEditorM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfCubit(),
      child: PdfEditordialogM(),
    );
  }
}

class PdfEditordialogM extends StatelessWidget {
  const PdfEditordialogM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Attach SoftCopy"),
          BlocBuilder<PdfCubit, PdfState>(
            builder: (context, state) {
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: state.mode == Mode.Create,
                      child: ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    withData: true,
                                    allowCompression: true,
                                    allowMultiple: true,
                                    type: FileType.image);
                            if (result != null) {
                              context
                                  .read<PdfCubit>()
                                  .fileselected(result.files);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: .3, color: Colors.grey),
                              elevation: 1,
                              primary: Colors.white,
                              onPrimary: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        height: 350,
        width: 700,
        child: BlocBuilder<PdfCubit, PdfState>(
          builder: (context, state) {
            if (state.mode != Mode.Create) {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<PdfCubit>().switchMode(Mode.Create);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Create Pdf document",
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "— or —",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowCompression: true,
                                  allowMultiple: false,
                                  withData: true);
                          if (result != null) {
                            Navigator.pop(context, result.files.single.bytes);
                          }
                        },
                        child: const Text(
                          'Upload one',
                          textScaleFactor: 0.75,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return FilesList();
          },
        ),
      ),
      actions: [Actions()],
    );
  }
}

class FilesList extends StatelessWidget {
  const FilesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          key: ValueKey(context.read<PdfCubit>().state.files[index]),
          title: Text(
            context.read<PdfCubit>().state.files[index].name,
          ),
        );
      },
      itemCount: context.read<PdfCubit>().state.files.length,
      onReorder: context.read<PdfCubit>().onReorder,
      buildDefaultDragHandles: true,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
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
          child: ElevatedButton(
            onPressed: () async {
              final pdf = await context.read<PdfCubit>().createPdf();
              Navigator.pop(context, pdf);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("save",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: .3, color: Colors.grey),
              elevation: 1,
              onPrimary: Colors.grey,
              primary: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
