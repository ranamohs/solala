import 'package:solala/core/constants/end_points.dart';
import '../../../shops/data/models/shops_model.dart';

class SearchModel {
  final List<ShopData> data;
  final Links links;
  final Meta meta;

  SearchModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      data: List<ShopData>.from(
        json[ApiKey.data].map((x) => ShopData.fromJson(x)),
      ),
      links: Links.fromJson(json[ApiKey.links]),
      meta: Meta.fromJson(json[ApiKey.meta]),
    );
  }
}