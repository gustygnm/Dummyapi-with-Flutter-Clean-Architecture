import 'package:dartz/dartz.dart';
import '../../data/models/data_model.dart';
import '../../common/failure.dart';

abstract class DataRepository {
  Future<Either<Failure, List<DataItem>>> getDataUsers();
  Future<Either<Failure, String>> save(DataItem value);
  Future<Either<Failure, String>> remove(DataItem value);
  Future<Either<Failure, String>> edit(DataItem value);
  Future<Either<Failure, DataItem?>> getDataById(String id);
  Future<Either<Failure, List<DataItem>>> getListUsers();
}
