import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../data/datasources/user_local_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/models/data_model.dart';
import '../../data/models/data_table.dart';
import '../../domain/repositories/data_repository.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';


class DataRepositoryImpl implements DataRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  DataRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<DataItem>>> getDataUsers() async {
    try {
      final result = await remoteDataSource.getDataUsers();
      return Right(result.data.map((data) => data.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }


  @override
  Future<Either<Failure, List<DataItem>>> getListUsers() async {
    final result = await localDataSource.getListData();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> remove(DataItem value) async {
    try {
      final result =
      await localDataSource.remove(DataTable.fromEntity(value));
    return Right(result);
    } on DatabaseException catch (e) {
    return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> edit(DataItem value) async {
    try {
      final result =
      await localDataSource.edit(DataTable.fromEntity(value));
    return Right(result);
    } on DatabaseException catch (e) {
    return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> save(DataItem value)  async {
    try {
      final result =
      await localDataSource.insert(DataTable.fromEntity(value));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, DataItem?>> getDataById(String id) async {
    try {
      final result =
          await localDataSource.getDataById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }
}
