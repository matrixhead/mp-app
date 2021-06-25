import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';
part 'categoryadder_state.dart';

class CategoryAdderCubit extends Cubit<CategoryAdderState> {
  CategoryAdderCubit(this.nivedhanamRepository) : super(CategoryAdderState());

  final NivedhanamRepository nivedhanamRepository;

  void addField() {
    emit(
      state.copyWith(
        categoryfields: Map.from(state.categoryfields)
          ..addAll({
            UniqueKey(): {"name": "", "type": "Text"}
          }),
      ),
    );
  }

  void nameChanged(text) {
    emit(state.copyWith(categoryName: text));
  }

  void fieldNameChaned(key, text) {
    emit(state.copyWith(
        categoryfields: Map.from(state.categoryfields)..[key]["name"] = text));
  }

  void dropdownChanged(Key? key, String newValue) {
    emit(state.copyWith(
        categoryfields: Map.from(state.categoryfields)
          ..[key]["type"] = newValue));
  }

  Future<String> onSubmitted() async {
    try {
      await nivedhanamRepository.addCategory(
          state.categoryName, state.categoryfields);
      return "Category created";
    } catch (_) {
      return (_.toString());
    }
  }
}
