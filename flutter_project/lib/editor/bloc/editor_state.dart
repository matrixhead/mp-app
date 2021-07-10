part of 'editor_bloc.dart';

enum SubmissionStatus {
  submissionSuccess,
  submissionFailure,
  submissionInProgress,
  pure
}
enum Mode { update, create }
enum ScanLoc { network, local }

class EditorState extends Equatable {
  final Map<String, dynamic> editorFormMap;
  final SubmissionStatus status;
  final Mode mode;
  final ScanLoc scanloc;
  final Uint8List? pdf;
  final List<Category> categories;

  EditorState({
    required this.editorFormMap,
    this.pdf,
    this.categories = const [],
    this.status = SubmissionStatus.pure,
    required this.mode,
    required this.scanloc,
  });

  EditorState copyWith(
      {Map<String, dynamic>? editorFormMap,
      SubmissionStatus? status,
      ScanLoc? scanloc,
      List<Category>? categories,
      Uint8List? pdf}) {
    return EditorState(
      scanloc: scanloc ?? this.scanloc,
      editorFormMap: editorFormMap ?? this.editorFormMap,
      status: status ?? this.status,
      mode: this.mode,
      pdf: pdf ?? this.pdf,
      categories: categories ?? this.categories,
    );
  }
  //  Uint8List dsfasf =pw.Document().save()
  // Future<Uint8List> get getPdf async => pdf ?? await pw.Document().save()

  @override
  List<Object?> get props => [
        editorFormMap,
        status,
        mode,
        pdf,
        categories,
      ];

  @override
  String toString() {
    return 'Homestate ';
  }
}
