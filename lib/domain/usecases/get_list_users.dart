import 'package:dartz/dartz.dart';
import '../../data/models/data_model.dart';
import '../../domain/repositories/data_repository.dart';
import '../../common/failure.dart';

class GetListUsers {
  final DataRepository _repository;

  GetListUsers(this._repository);

  Future<Either<Failure, List<DataItem>>> execute() {
    return _repository.getListUsers();
  }
}
