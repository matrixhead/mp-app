import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/recent_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'home_state.dart';
part 'home_event.dart';

const int nivedhanamLimit = 40;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(NivedhanamRepository nivedhanamRepository,
      AuthenticationRepository authenticationRepository)
      : nivedhanamRepository = nivedhanamRepository,
        authenticationRepository = authenticationRepository,
        super(HomeState());
  NivedhanamRepository nivedhanamRepository;
  AuthenticationRepository authenticationRepository;

  @override
  Stream<Transition<HomeEvent, HomeState>> transformEvents(
    Stream<HomeEvent> events,
    TransitionFunction<HomeEvent, HomeState> transitionFn,
  ) {
    var fetchEventStream = events
        .where((event) => event is NivedhanamFetchedEvent)
        .debounceTime(const Duration(milliseconds: 500));
    var otherEventStream =
        events.where((event) => event is! NivedhanamFetchedEvent);
    var combined = Rx.merge([fetchEventStream, otherEventStream]);
    return super.transformEvents(
      combined,
      transitionFn,
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is NivedhanamFetchedEvent) {
      yield await _mapNivedhanamFetchedToState(state);
    } else if (event is RefreshNivedhanamEvent) {
      yield _refreshNivedhanamToState(state);
    } else if (event is CategoryFetchedEvent) {
      yield await categoryFetchedEventToState();
    } else if (event is SearchEditedEvent) {
      yield searchEditedToState(event);
    } else if (event is NavigationRailIndexChangedEvent) {
      yield navigationIndexChangedToState(event);
    } else if (event is OverviewFetchedEvent) {
      yield await overviewFetcehdEventToState();
    } else if (event is FetchSiFromSpEvent) {
      yield await fetchSIfromSPtoState();
    } else if (event is FetchRecentEvent) {
      yield await fetchRecentEvenToState(event);
    } else if (event is AddNivedhanamToRecent) {
      yield addNivedhanamToRecentToState(event);
    }
  }

  Future<HomeState> _mapNivedhanamFetchedToState(HomeState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == NivedhanamStatus.initial) {
        final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
            searchquery: state.searchString,
            postLimit: nivedhanamLimit,
            token: authenticationRepository.getUser.token);
        return state.copyWith(
          status: NivedhanamStatus.success,
          nivedhanams: nivedhanams,
          hasReachedMax: false,
        );
      }
      final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
          searchquery: state.searchString,
          startIndex: state.nivedhanams.length,
          postLimit: nivedhanamLimit,
          token: authenticationRepository.getUser.token);
      return nivedhanams.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: NivedhanamStatus.success,
              nivedhanams: List.of(state.nivedhanams)..addAll(nivedhanams),
              hasReachedMax: nivedhanams.length < nivedhanamLimit,
            );
    } on Exception {
      return state.copyWith(status: NivedhanamStatus.failure);
    }
  }

  HomeState _refreshNivedhanamToState(HomeState state) {
    this.add(NivedhanamFetchedEvent());
    this.add(CategoryFetchedEvent());
    this.add(OverviewFetchedEvent());
    this.add(FetchRecentEvent());
    return state.copyWith(
        status: NivedhanamStatus.initial,
        nivedhanams: [],
        hasReachedMax: false,
        categories: []);
  }

  Future<HomeState> categoryFetchedEventToState() async {
    return state.copyWith(
        categories: await nivedhanamRepository.fetchCategory());
  }

  HomeState searchEditedToState(event) {
    this.add(RefreshNivedhanamEvent());
    return state.copyWith(searchString: event.input, navigationRailindex: 1);
  }

  HomeState navigationIndexChangedToState(event) {
    return state.copyWith(navigationRailindex: event.index);
  }

  Future<HomeState> overviewFetcehdEventToState() async {
    return state.copyWith(
        overview: await nivedhanamRepository
            .fetchOverview(authenticationRepository.getUser.token));
  }

  Future<HomeState> fetchSIfromSPtoState() async {
    this.add(
        FetchRecentEvent(sino: await nivedhanamRepository.fetchSIfromSP()));
    return state;
  }

  Future<HomeState> fetchRecentEvenToState(FetchRecentEvent event) async {
    if (event.sino == null) {
      final List<Nivedhanam> cachedNivedhanam = [];
      for (Nivedhanam nivedhanam in state.recent.recentNivedhanams) {
        final newnivedhanam = await nivedhanamRepository.fetchSingleNivedhanam(
            nivedhanam.siNo.toString(), authenticationRepository.getUser.token);
        cachedNivedhanam.add(newnivedhanam);
      }
      return state.copyWith(recent: Recent(cachedNivedhanam));
    } else {
      final List<Nivedhanam> cachedNivedhanam = [];
      for (String sino in event.sino ?? []) {
        final nivedhanam = await nivedhanamRepository.fetchSingleNivedhanam(
            sino, authenticationRepository.getUser.token);
        cachedNivedhanam.add(nivedhanam);
      }
      return state.copyWith(recent: Recent(cachedNivedhanam));
    }
  }

  HomeState addNivedhanamToRecentToState(AddNivedhanamToRecent event) {
    final newState =
        state.copyWith(recent: state.recent.addNivedhanam(event.nivedhanam));
    nivedhanamRepository.saveSIToSP(newState.recent.recentNivedhanams
        .map((e) => e.siNo.toString())
        .toList());

    return newState;
  }
}
