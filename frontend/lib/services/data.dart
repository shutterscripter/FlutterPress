import 'package:news_app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.categoryName = "Technology";
  categoryModel.image = "assets/tech.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.categoryName = "Science";
  categoryModel.image = "assets/scie.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.categoryName = "Entertainment";
  categoryModel.image = "assets/entertain.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Health";
  categoryModel.image = "assets/health.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.categoryName = "Business";
  categoryModel.image = "assets/business.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.categoryName = "Sports";
  categoryModel.image = "assets/sports.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}
