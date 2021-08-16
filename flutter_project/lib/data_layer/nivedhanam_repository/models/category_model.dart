import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int categoryId;
  final String categoryName;
  final Map categoryFields;

  Category(this.categoryName, this.categoryFields,this.categoryId);

  Category.fromJson(Map<String, dynamic> json)
      : categoryId = json["category_id"],
        categoryName = json["category_name"],
        categoryFields = json["categoryfields"];

  @override
  List<Object?> get props => [categoryName, categoryFields,categoryId];
}
