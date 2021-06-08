part of 'editor_bloc.dart';

enum SubmissionStatus {
  submissionSuccess,
  submissionFailure,
  submissionInProgress,
  pure
}

class EditorState extends Equatable {
  final Map<String, dynamic> editorFormMap;
  final SubmissionStatus status;

  const EditorState(
      {this.editorFormMap = const {}, this.status = SubmissionStatus.pure});

  EditorState copyWith(
      {Map<String, dynamic>? editorFormMap, SubmissionStatus? status}) {
    return EditorState(
      editorFormMap: editorFormMap ?? this.editorFormMap,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [editorFormMap];
}
