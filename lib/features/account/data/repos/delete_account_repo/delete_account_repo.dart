
import '../../../../../core/data/models/basic_model.dart';

abstract class DeleteAccountRepo {
  Future<BasicModel> deleteAccount();
}
