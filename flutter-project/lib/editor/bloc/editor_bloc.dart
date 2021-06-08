import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(
    NivedhanamRepository nivedhanamRepository,
  ) : super(EditorState());

  @override
  Stream<EditorState> mapEventToState(EditorEvent event) async* {
    if (event is FormEditedEvent) {
      yield formEditedEventToState(event, state);
    } else if (event is FormSubmittedEvent) {
      yield* formSubmittedToState(state);
    }
  }

  EditorState formEditedEventToState(FormEditedEvent event, EditorState state) {
    return state.copyWith(
        editorFormMap: Map.from(state.editorFormMap)..addAll(event.input));
  }

  Stream<EditorState> formSubmittedToState(EditorState state) async* {
    yield state.copyWith(status: SubmissionStatus.submissionInProgress);
    try {} on Exception catch (_) {
      yield state.copyWith(status: SubmissionStatus.submissionFailure);
    }
  }
}
