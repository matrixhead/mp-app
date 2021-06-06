part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();
  @override
  List<Object> get props => [];
}

class AddedNameEvent extends EditorEvent {}
