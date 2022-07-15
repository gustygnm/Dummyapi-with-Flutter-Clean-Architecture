import '../../data/datasources/db/database_helper.dart';
import '../../data/datasources/user_local_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/data_repository_impl.dart';
import '../../domain/repositories/data_repository.dart';
import '../../domain/usecases/edit.dart';
import '../../domain/usecases/get_data_by_id.dart';
import '../../domain/usecases/get_data_users.dart';
import '../../domain/usecases/get_list_users.dart';
import '../../domain/usecases/remove.dart';
import '../../domain/usecases/save.dart';
import '../../presentation/provider/detail_page_notifier.dart';
import '../../presentation/provider/home_page_notifier.dart';
import '../../presentation/provider/add_page_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => DetailPageNotifier(
      removeData: locator(),
      getDataById: locator(),
    ),
  );
  locator.registerFactory(
    () => HomePageNotifier(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => AddPageNotifier(
      addData: locator(),
      editData: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetDataUsers(locator()));
  locator.registerLazySingleton(() => Save(locator()));
  locator.registerLazySingleton(() => Remove(locator()));
  locator.registerLazySingleton(() => Edit(locator()));
  locator.registerLazySingleton(() => GetDataById(locator()));
  locator.registerLazySingleton(() => GetListUsers(locator()));

  // repository
  locator.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<UserLocalDataSource>(
      () => DataLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
