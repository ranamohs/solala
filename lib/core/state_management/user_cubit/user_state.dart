import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool isGuest;

  const UserState({required this.isGuest});

  @override
  List<Object?> get props => [isGuest];
}
