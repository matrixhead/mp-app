part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class NivedhanamFetchedEvent extends HomeEvent {}

class CategoryFetchedEvent extends HomeEvent {}

class RefreshNivedhanamEvent extends HomeEvent {}
