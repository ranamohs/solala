abstract class Failure {
  final String errMessage;
  Failure({required this.errMessage});
}

class NoInternetFailure extends Failure {
  NoInternetFailure({required super.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure({required super.errMessage});
}
