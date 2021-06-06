import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(EditorState initialState) : super(initialState);

  @override
  Stream<EditorState> mapEventToState(EditorEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
