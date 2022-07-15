import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../../data/models/data_model.dart';
import '../../domain/repositories/data_repository.dart';

class GetDataById {
  final DataRepository repository;

  GetDataById(this.repository);

  Future<Either<Failure, DataItem?>> execute(String id) {
    return repository.getDataById(id);
  }
}
