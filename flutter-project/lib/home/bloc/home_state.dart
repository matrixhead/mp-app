part of 'home_bloc.dart';

enum NivedhanamStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = NivedhanamStatus.initial,
    this.nivedhanams = const <Nivedhanam>[],
    this.hasReachedMax = false,
  });

  final List<Nivedhanam> nivedhanams;
  final bool hasReachedMax;
  final NivedhanamStatus status;

  HomeState copyWith({
    NivedhanamStatus? status,
    List<Nivedhanam>? nivedhanams,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      nivedhanams: nivedhanams ?? this.nivedhanams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
