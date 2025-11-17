import 'package:flutter/material.dart';

import '../../../data/models/wishlist_model.dart';

@immutable
abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistSuccess extends WishlistState {
  final WishlistModel? wishlistModel;

  WishlistSuccess({this.wishlistModel});
}


class WishlistFailure extends WishlistState {
  final String errorMessage;

  WishlistFailure({required this.errorMessage});
}