import 'package:equatable/equatable.dart';


import '../../../../core/errors/failure.dart';
import '../../../shops/data/models/shops_model.dart';

abstract class ShopsSearchState extends Equatable {
  const ShopsSearchState();

  @override
  List<Object?> get props => [];
}

class ShopsSearchInitial extends ShopsSearchState {
  const ShopsSearchInitial();
}

class ShopsSearchLoading extends ShopsSearchState {
  const ShopsSearchLoading();
}

class ShopsSearchSuccess extends ShopsSearchState {
  final ShopsModel shopsModel;

  const ShopsSearchSuccess({required this.shopsModel});

  @override
  List<Object?> get props => [shopsModel];
}

class ShopsSearchFailure extends ShopsSearchState {
  final Failure failure;

  const ShopsSearchFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}