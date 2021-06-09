import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(
    NivedhanamRepository nivedhanamRepository,
    AuthenticationRepository authenticationRepository,
  )   : nivedhanamRepository = nivedhanamRepository,
        authenticationRepository = authenticationRepository,
        super(EditorState());

  final NivedhanamRepository nivedhanamRepository;
  final AuthenticationRepository authenticationRepository;

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
    try {
      await nivedhanamRepository.createNivedhanam(
        nivedhanamMap: state.editorFormMap,
        token: authenticationRepository.getUser.token,
      );
      yield state.copyWith(status: SubmissionStatus.submissionSuccess);
    } on Exception catch (_) {
      yield state.copyWith(status: SubmissionStatus.submissionFailure);
      print(_);
    }
  }
}
