import 'dart:convert';

import '../../data/models/data_model.dart';
import '../../common/exception.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<DataModel> getDataUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  static const APP_ID = '62cb77c1bcf012696801bcad';
  static const BASE_URL = 'https://dummyapi.io';

  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<DataModel> getDataUsers() async {

        final response =
        await client.get(Uri.parse('$BASE_URL/data/v1/user?limit=50'),headers: {"app-id": APP_ID});

    if (response.statusCode == 200) {
      return DataModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
