part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();
  @override
  List<Object> get props => [];
}

class FormEditedEvent extends EditorEvent {
  const FormEditedEvent(this.input);
  final Map<String, dynamic> input;

  @override
  List<Object> get props => [input];
}

class FormSubmittedEvent extends EditorEvent {}

class FetchScannedImages extends EditorEvent {
  const FetchScannedImages(this.sino);
  final String? sino;
  @override
  List<Object> get props => [sino ?? ""];
}

class FilesSelectedEvent extends EditorEvent {
  FilesSelectedEvent(this.pdf);
  final pdf;
  @override
  List<Object> get props => [pdf];
  @override
  String toString() {
    return '';
  }
}

class CategoryFetchedEvent extends EditorEvent {}
