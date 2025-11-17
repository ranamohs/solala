import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';

abstract class AddReviewState extends Equatable {
  const AddReviewState();

  @override
  List<Object> get props => [];
}

class AddReviewInitial extends AddReviewState {}

class AddReviewLoading extends AddReviewState {}

class AddReviewSuccess extends AddReviewState {}

class AddReviewFailure extends AddReviewState {
  final Failure failure;

  const AddReviewFailure(this.failure);

  @override
  List<Object> get props => [failure];
}