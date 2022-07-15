import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../../domain/repositories/data_repository.dart';

import '../../data/models/data_model.dart';

class GetDataUsers {
  final DataRepository repository;

  GetDataUsers(this.repository);

  Future<Either<Failure, List<DataItem>>> execute() {
    return repository.getDataUsers();
  }
}
