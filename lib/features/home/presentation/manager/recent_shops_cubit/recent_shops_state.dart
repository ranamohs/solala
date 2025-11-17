import 'package:solala/core/errors/failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/categories_models/recent_shops_models.dart';

abstract class RcenetShopsState extends Equatable {
  const RcenetShopsState();

  @override
  List<Object?> get props => [];
}

class RcenetShopsInitial extends RcenetShopsState {
  const RcenetShopsInitial();
}

class RcenetShopsLoading extends RcenetShopsState {
  const RcenetShopsLoading();
}

class RcenetShopsSuccess extends RcenetShopsState {
  final RcenetShopsModel categoriesModel;

  const RcenetShopsSuccess({required this.categoriesModel});

  @override
  List<Object?> get props => [categoriesModel];
}

class RcenetShopsFailure extends RcenetShopsState {
  final Failure failure;

  const RcenetShopsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}