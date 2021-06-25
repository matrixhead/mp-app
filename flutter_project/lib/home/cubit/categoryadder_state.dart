part of 'categoryadder_cubit.dart';

class CategoryAdderState extends Equatable {
  const CategoryAdderState({
    this.categoryfields = const {},
    this.categoryName = "",
  });

  final String categoryName;
  final Map categoryfields;

  CategoryAdderState copyWith(
      {String? categoryName, Map? categoryfields, int? numberOfFields}) {
    return CategoryAdderState(
      categoryName: categoryName ?? this.categoryName,
      categoryfields: categoryfields ?? this.categoryfields,
    );
  }

  @override
  List<Object> get props => [
        categoryName,
        categoryfields,
      ];
}
