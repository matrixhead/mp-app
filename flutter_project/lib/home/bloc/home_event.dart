part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class NivedhanamFetchedEvent extends HomeEvent {}

class CategoryFetchedEvent extends HomeEvent {}

class RefreshNivedhanamEvent extends HomeEvent {}

class SearchEditedEvent extends HomeEvent {
  const SearchEditedEvent(this.input);
  final String input;
  @override
  List<Object> get props => [input];
}

class NavigationRailIndexChangedEvent extends HomeEvent {
  const NavigationRailIndexChangedEvent(this.index);
  final int index;
  List<Object> get props => [index];
}

class OverviewFetchedEvent extends HomeEvent {}

class FetchSiFromSpEvent extends HomeEvent {}

class FetchRecentEvent extends HomeEvent {
  final List? sino;
  const FetchRecentEvent({this.sino});
}

class AddNivedhanamToRecent extends HomeEvent {
  final Nivedhanam nivedhanam;
  AddNivedhanamToRecent(this.nivedhanam);
}
