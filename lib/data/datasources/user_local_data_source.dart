import '../../common/exception.dart';
import '../../data/datasources/db/database_helper.dart';
import '../../data/models/data_model.dart';
import '../../data/models/data_table.dart';

abstract class UserLocalDataSource {
  Future<String> insert(DataTable value);
  Future<String> remove(DataTable value);
  Future<String> edit(DataTable value);
  Future<DataItem?> getDataById(String id);
  Future<List<DataItem>> getListData();
}

class DataLocalDataSourceImpl implements UserLocalDataSource {
  final DatabaseHelper databaseHelper;

  DataLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insert(DataTable value) async {
    try {
      await databaseHelper.insert(value);
      return 'Added success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> remove(DataTable value) async {
    try {
      await databaseHelper.remove(value);
      return 'Removed success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> edit(DataTable value) async {
    try {
      await databaseHelper.edit(value);
      return 'Edit success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<DataItem?> getDataById(String id) async {
    final result = await databaseHelper.getDataById(id);
    if (result != null) {
      return DataItem.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<DataItem>> getListData() async {
    final result = await databaseHelper.getListData();
    return result.map((data) => DataItem.fromJson(data)).toList();
  }
}
