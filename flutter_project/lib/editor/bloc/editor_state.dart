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
  final Map<int, dynamic> imageList;
  final List<Category> categories;

  EditorState({
    required this.editorFormMap,
    this.imageList = const {},
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
      Map<int, dynamic>? imageList}) {
    return EditorState(
      scanloc: scanloc ?? this.scanloc,
      editorFormMap: editorFormMap ?? this.editorFormMap,
      status: status ?? this.status,
      mode: this.mode,
      imageList: imageList ?? this.imageList,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        editorFormMap,
        status,
        mode,
        imageList,
        categories,
      ];
}
