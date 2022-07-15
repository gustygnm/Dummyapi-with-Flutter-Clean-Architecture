import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../../data/models/data_model.dart';
import '../../domain/repositories/data_repository.dart';

class Edit {
  final DataRepository repository;

  Edit(this.repository);

  Future<Either<Failure, String>> execute(DataItem value) {
    return repository.edit(value);
  }
}
