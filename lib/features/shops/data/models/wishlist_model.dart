import 'package:solala/features/shops/data/models/shops_model.dart';

class WishlistModel {
  final bool status;
  final String message;
  final List<WishlistItem> data;

  WishlistModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      status: json['status'],
      message: json['message']['en'],
      data: List<WishlistItem>.from(
        json['data'].map((x) => WishlistItem.fromJson(x)),
      ),
    );
  }
}

class WishlistItem {
  final int id;
  final String shopId;
  final ShopData product;
  final String addedAt;

  WishlistItem({
    required this.id,
    required this.shopId,
    required this.product,
    required this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      shopId: json['shop_id'],
      product: ShopData.fromJson(json['product']),
      addedAt: json['added_at'],
    );
  }
}