import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(
    NivedhanamRepository nivedhanamRepository,
    AuthenticationRepository authenticationRepository,
    nivedhanam,
  )   : nivedhanamRepository = nivedhanamRepository,
        authenticationRepository = authenticationRepository,
        super(EditorState(
            editorFormMap: nivedhanam ?? Map<String, String>(),
            mode: nivedhanam == null ? Mode.create : Mode.update,
            scanloc: nivedhanam == null ? ScanLoc.local : ScanLoc.network));

  final NivedhanamRepository nivedhanamRepository;
  final AuthenticationRepository authenticationRepository;

  @override
  Stream<EditorState> mapEventToState(EditorEvent event) async* {
    if (event is FormEditedEvent) {
      yield formEditedEventToState(event, state);
    } else if (event is FormSubmittedEvent) {
      yield* formSubmittedToState(state);
    } else if (event is FetchScannedImages) {
      yield await fetchScannedImagesTostate(event, state);
    } else if (event is FilesSelectedEvent) {
      yield await filesSelectedEventToState(event);
    } else if (event is CategoryFetchedEvent) {
      yield await categoryFetchedEventToState();
    }
  }

  EditorState formEditedEventToState(FormEditedEvent event, EditorState state) {
    if (event.input.values.first is Map) {
      final Map currentMap =
          Map.from(state.editorFormMap['categoryfields'] ?? {});
      currentMap.addAll(event.input["categoryfields"]);
      return state.copyWith(
          editorFormMap: Map.from(state.editorFormMap)
            ..addAll({'categoryfields': currentMap}));
    }
    return state.copyWith(
        editorFormMap: Map.from(state.editorFormMap)..addAll(event.input));
  }

  Stream<EditorState> formSubmittedToState(EditorState state) async* {
    yield state.copyWith(status: SubmissionStatus.submissionInProgress);
    final serialisedNivedhanam = Map.from(state.editorFormMap)
      ..update("categoryfields", (value) => jsonEncode(value),
          ifAbsent: () => jsonEncode({}));
    serialisedNivedhanam.removeWhere((key, value) => value == null);
    try {
      if (state.mode == Mode.create) {
        await nivedhanamRepository.createNivedhanam(
            nivedhanamMap: serialisedNivedhanam,
            token: authenticationRepository.getUser.token,
            pdf: state.scanloc == ScanLoc.local ? state.pdf : null);
      } else {
        nivedhanamRepository.updateNivedhanam(
            nivedhanamMap: serialisedNivedhanam,
            token: authenticationRepository.getUser.token,
            pdf: state.scanloc == ScanLoc.local ? state.pdf : null);
      }
      yield state.copyWith(status: SubmissionStatus.submissionSuccess);
    } on Exception catch (_) {
      yield state.copyWith(status: SubmissionStatus.submissionFailure);
      print(_);
    }
  }

  Future<EditorState> fetchScannedImagesTostate(
      FetchScannedImages event, EditorState state) async {
    if (state.scanloc == ScanLoc.network) {
      try {
        return state.copyWith(
            pdf: await nivedhanamRepository.fetchscan(event.sino));
      } on Exception catch (_) {
        print(_);
      }
    }
    return state.copyWith();
  }

  Future<EditorState> filesSelectedEventToState(
      FilesSelectedEvent event) async {
    return state.copyWith(pdf: event.pdf, scanloc: ScanLoc.local);
  }

  Future<EditorState> categoryFetchedEventToState() async {
    return state.copyWith(
        categories: List.from(await nivedhanamRepository.fetchCategory()));
  }
}
