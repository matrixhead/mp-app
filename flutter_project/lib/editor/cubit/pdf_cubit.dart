import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:file_picker/src/platform_file.dart';
part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfState(mode: Mode.pure));

  void fileselected(List<PlatformFile> files) async {
    emit(state.copyWith(files: List.from(state.files)..addAll(files)));

    // final pdf = pw.Document();
    // files.forEach((element) {
    //   final image = pw.MemoryImage(element.bytes ?? Uint8List(0));
    //   pdf.addPage(pw.Page(build: (pw.Context context) {
    //     return pw.Center(
    //       child: pw.Image(image),
    //     );
    //   }));
    // });

    // final content = base64Encode(await pdf.save());
    // final anchor = AnchorElement(
    //     href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    //   ..setAttribute("download", "file.pdf")
    //   ..click();
    // return await pdf.save();
  }

  void onReorder(int oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<PlatformFile> fileList = List.from(state.files);
    final reOrderedItem = fileList.removeAt(oldIndex);
    emit(state.copyWith(files: fileList..insert(newIndex, reOrderedItem)));
  }

  void switchMode(Mode mode) {
    emit(state.copyWith(mode: mode));
  }

  Future<Uint8List> createPdf() async {
    final pdf = pw.Document();
    state.files.forEach((element) {
      final image = pw.MemoryImage(element.bytes ?? Uint8List(0));
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        );
      }));
    });
    return await pdf.save();
  }

  void onRemove(int index) {
    final List<PlatformFile> fileList = List.from(state.files);
    fileList.removeAt(index);
    emit(state.copyWith(files: fileList));
  }
}
