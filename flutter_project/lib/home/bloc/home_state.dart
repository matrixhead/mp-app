part of 'home_bloc.dart';

enum NivedhanamStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = NivedhanamStatus.initial,
    this.nivedhanams = const <Nivedhanam>[],
    this.categories = const <Category>[],
    this.hasReachedMax = false,
  });
  final List<Category> categories;
  final List<Nivedhanam> nivedhanams;
  final bool hasReachedMax;
  final NivedhanamStatus status;

  HomeState copyWith({
    List<Category>? categories,
    NivedhanamStatus? status,
    List<Nivedhanam>? nivedhanams,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      nivedhanams: nivedhanams ?? this.nivedhanams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [status, nivedhanams, hasReachedMax, categories];

  @override
  String toString() {
    return '''Homestate { status: $status, hasReachedMax: $hasReachedMax, nivedhanams: ${nivedhanams.length}, category: $categories }''';
  }
}
