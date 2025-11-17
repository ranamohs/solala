
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/request_service_success_model.dart';

abstract class RequestServiceRepo {
  Future<Either<Failure, RequestServiceSuccessModel>> selectedService({
    required int shopId,
  });
}
