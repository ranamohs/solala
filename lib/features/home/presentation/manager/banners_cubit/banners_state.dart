import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/banners_models/banners_model.dart';
import 'package:equatable/equatable.dart';

abstract class BannersState extends Equatable {
  const BannersState();

  @override
  List<Object?> get props => [];
}

class BannersInitial extends BannersState {
  const BannersInitial();
}

class BannersLoading extends BannersState {
  const BannersLoading();
}

class BannersSuccess extends BannersState {
  final BannersModel bannersModel;

  const BannersSuccess(this.bannersModel);

  @override
  List<Object?> get props => [bannersModel];
}

class BannersFailure extends BannersState {
  final Failure failure;

  const BannersFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
