part of 'editor_bloc.dart';

enum SubmissionStatus {
  submissionSuccess,
  submissionFailure,
  submissionInProgress,
  pure
}

enum Mode { update, create }

class EditorState extends Equatable {
  final Map<String, String> editorFormMap;
  final SubmissionStatus status;
  final Mode mode;

  const EditorState(
      {this.editorFormMap = const {},
      this.status = SubmissionStatus.pure,
      this.mode = Mode.create});

  EditorState copyWith(
      {Map<String, String>? editorFormMap, SubmissionStatus? status}) {
    return EditorState(
      editorFormMap: editorFormMap ?? this.editorFormMap,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [editorFormMap, status];
}
