import 'package:solala/features/home/data/models/categories_models/categories_model.dart';

class RcenetShopsModel {
  final List<CategoryData> data;

  RcenetShopsModel({required this.data});

  factory RcenetShopsModel.fromJson(Map<String, dynamic> json) {
    return RcenetShopsModel(
      data: List<CategoryData>.from(
        json['data'].map((x) => CategoryData.fromJson(x)),
      ),
    );
  }
}