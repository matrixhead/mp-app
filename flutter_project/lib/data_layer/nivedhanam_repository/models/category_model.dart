import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String categoryName;
  final Map categoryFields;

  Category(this.categoryName, this.categoryFields);

  Category.fromJson(Map<String, dynamic> json)
      : categoryName = json["category_name"],
        categoryFields = json["categoryfields"];

  @override
  List<Object?> get props => [categoryName, categoryFields];
}
