import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
part "categoryeditor_state.dart";

class CategoryEditorCubit extends Cubit<CategoryEditorState>{
  CategoryEditorCubit(this.nivedhanamRepository) : super(CategoryEditorState());
  final NivedhanamRepository nivedhanamRepository;

  Future<int> deleteCategory(int categoryId) async{
    return await nivedhanamRepository.deletecategory(categoryId);
  }

  updateCategory(String name, Category category) async{
    return await nivedhanamRepository.updatecategory(name,category.categoryId.toString());
  }
  
}