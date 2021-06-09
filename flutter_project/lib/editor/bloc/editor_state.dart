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

  EditorState({
    required this.editorFormMap,
    this.status = SubmissionStatus.pure,
    required this.mode,
  });

  EditorState copyWith(
      {Map<String, String>? editorFormMap, SubmissionStatus? status}) {
    return EditorState(
        editorFormMap: editorFormMap ?? this.editorFormMap,
        status: status ?? this.status,
        mode: this.mode);
  }

  @override
  List<Object?> get props => [editorFormMap, status, mode];
}
