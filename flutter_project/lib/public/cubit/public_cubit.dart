import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'public_state.dart';

class PublicCubit extends Cubit<PublicState> {
  PublicCubit() : super(PublicInitial());
}
