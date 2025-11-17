import 'package:solala/core/errors/failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/shops_model.dart';


abstract class ShopsState extends Equatable {
  const ShopsState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ShopsState {
  const ServicesInitial();
}

class ServicesLoading extends ShopsState {
  const ServicesLoading();
}

class ServicesSuccess extends ShopsState {
  final ShopsModel servicesModel;
  final int currentPage;
  final int lastPage;

  const ServicesSuccess({
    required this.servicesModel,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [servicesModel, currentPage, lastPage];
}

class ServicesLoadingMore extends ShopsState {
  final ShopsModel servicesModel;
  final int currentPage;
  final int lastPage;

  const ServicesLoadingMore({
    required this.servicesModel,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [servicesModel, currentPage, lastPage];
}

class ServicesFailure extends ShopsState {
  final Failure failure;

  const ServicesFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
