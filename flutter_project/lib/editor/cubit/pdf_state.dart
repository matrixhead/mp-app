part of 'pdf_cubit.dart';

enum Mode { Create, Upload, pure }

class PdfState extends Equatable {
  final Mode mode;
  final List<PlatformFile> files;
  const PdfState({
    this.mode = Mode.pure,
    this.files = const [],
  });

  PdfState copyWith({
    Mode? mode,
    List<PlatformFile>? files,
  }) {
    return PdfState(
      mode: mode ?? this.mode,
      files: files ?? this.files,
    );
  }

  @override
  List<Object> get props => [mode, files];
}
