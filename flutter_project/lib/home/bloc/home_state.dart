part of 'home_bloc.dart';

enum NivedhanamStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = NivedhanamStatus.initial,
    this.nivedhanams = const <Nivedhanam>[],
    this.categories = const <Category>[],
    this.hasReachedMax = false,
    this.searchString = "",
    this.navigationRailindex = 0,
    this.overview = const {},
    this.recent = const Recent(const []),
  });
  final List<Category> categories;
  final List<Nivedhanam> nivedhanams;
  final bool hasReachedMax;
  final NivedhanamStatus status;
  final String searchString;
  final int navigationRailindex;
  final Map overview;
  final Recent recent;

  HomeState copyWith(
      {List<Category>? categories,
      NivedhanamStatus? status,
      List<Nivedhanam>? nivedhanams,
      bool? hasReachedMax,
      String? searchString,
      int? navigationRailindex,
      Map? overview,
      Recent? recent}) {
    return HomeState(
      recent: recent ?? this.recent,
      navigationRailindex: navigationRailindex ?? this.navigationRailindex,
      searchString: searchString ?? this.searchString,
      status: status ?? this.status,
      nivedhanams: nivedhanams ?? this.nivedhanams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      categories: categories ?? this.categories,
      overview: overview ?? this.overview,
    );
  }

  @override
  List<Object?> get props => [
        status,
        nivedhanams,
        hasReachedMax,
        categories,
        searchString,
        navigationRailindex,
        overview,
        recent
      ];

  @override
  String toString() {
    return '''Homestate { status: $status, hasReachedMax: $hasReachedMax, nivedhanams: ${nivedhanams.length}, category: $categories , search : $searchString }''';
  }
}
