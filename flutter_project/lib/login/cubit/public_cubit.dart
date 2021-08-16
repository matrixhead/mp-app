
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/login/cubit/public_state.dart';

class PublicCubit extends Cubit<PublicState>{
  PublicCubit(this.nivedhanamRepository) : super(PublicState());

  final NivedhanamRepository nivedhanamRepository;
}