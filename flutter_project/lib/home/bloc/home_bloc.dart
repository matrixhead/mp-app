import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
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
    }
  }

  Future<HomeState> _mapNivedhanamFetchedToState(HomeState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == NivedhanamStatus.initial) {
        final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
            postLimit: nivedhanamLimit,
            token: authenticationRepository.getUser.token);
        return state.copyWith(
          status: NivedhanamStatus.success,
          nivedhanams: nivedhanams,
          hasReachedMax: false,
        );
      }
      final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
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
}
