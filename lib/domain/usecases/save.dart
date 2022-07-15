import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../../data/models/data_model.dart';
import '../../domain/repositories/data_repository.dart';

class Save {
  final DataRepository repository;

  Save(this.repository);

  Future<Either<Failure, String>> execute(DataItem value) {
    return repository.save(value);
  }
}
