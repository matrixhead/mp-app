import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/authentication_repository/authentication.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'home_state.dart';
part 'home_event.dart';

const int postLimit = 30;

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
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is NivedhanamFetchedEvent) {
      yield await _mapNivedhanamFetchedToState(state);
    }
  }

  Future<HomeState> _mapNivedhanamFetchedToState(HomeState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == NivedhanamStatus.initial) {
        final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
            postLimit: postLimit,
            token: authenticationRepository.getUser.token);
        return state.copyWith(
          status: NivedhanamStatus.success,
          nivedhanams: nivedhanams,
          hasReachedMax: false,
        );
      }
      final nivedhanams = await nivedhanamRepository.fetchNivedhanam(
          startIndex: state.nivedhanams.length,
          postLimit: postLimit,
          token: authenticationRepository.getUser.token);
      return nivedhanams.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: NivedhanamStatus.success,
              nivedhanams: List.of(state.nivedhanams)..addAll(nivedhanams),
              hasReachedMax: nivedhanams.length < postLimit,
            );
    } on Exception {
      return state.copyWith(status: NivedhanamStatus.failure);
    }
  }
}
