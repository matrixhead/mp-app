import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/editor/bloc/editor_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'pdf_editor.dart';

class ScanView extends StatefulWidget {
  const ScanView({
    Key? key,
  }) : super(key: key);

  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  late EditorBloc _editBloc;
  late PdfController _pageController;

  @override
  void initState() {
    _editBloc = context.read<EditorBloc>();
    _pageController = PdfController(
        document: PdfDocument.openData(_editBloc.state.pdf ?? Uint8List(0)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: BlocListener<EditorBloc, EditorState>(
        listenWhen: (oldState, newState) => oldState.pdf != newState.pdf,
        listener: (context, state) {
          if (state.pdf != null) {
            _pageController
                .loadDocument(PdfDocument.openData(state.pdf ?? Uint8List(0)));
          }
        },
        child: BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (oldState, newState) => oldState.pdf != newState.pdf,
          builder: (context, state) {
            return Stack(
              children: [
                PdfView(
                  errorBuilder: (o) {
                    return Center(
                      child: Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.grey.withAlpha(30),
                        size: 500,
                      ),
                    );
                  },
                  controller: _pageController,
                ),
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                          context: context, builder: _pdfEditor);
                      if (result != null) {
                        _editBloc.add(FilesSelectedEvent(result));
                      }
                    },
                    child: Icon(
                      Icons.post_add,
                      size: 25,
                      color: Colors.black87,
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
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
      ),
    );
  }

  Widget _pdfEditor(BuildContext context) {
    return PdfEditor();
  }
}
