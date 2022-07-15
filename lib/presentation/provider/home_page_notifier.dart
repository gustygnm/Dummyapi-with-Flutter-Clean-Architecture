import '../../common/state_enum.dart';
import '../../data/models/data_model.dart';
import '../../domain/usecases/get_data_users.dart';
import '../../domain/usecases/remove.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_list_users.dart';
import '../../domain/usecases/save.dart';

class HomePageNotifier extends ChangeNotifier {
  static const successMessage = 'Removed success';

  final GetDataUsers getDataUsers;
  final Save saveData;
  final Remove removeData;
  final GetListUsers getListUsers;

  HomePageNotifier(
      this.getDataUsers, this.saveData, this.getListUsers, this.removeData);

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<DataItem> _listUser = [];
  List<DataItem> _users = [];

  List<DataItem> get users => _users;

  String _message = '';

  String get message => _message;

  Future<void> fetchDataUsers(bool ambil) async {
    final data = await getListUsers.execute();
    await data.fold(
      (failure) async {},
      (successMessage) async {
        _listUser = successMessage;
        notifyListeners();
      },
    );

    _state = RequestState.Loading;
    notifyListeners();
    final result;
    if (_listUser.isNotEmpty) {
      result = await getListUsers.execute();
    } else if (ambil) {
      result = await getListUsers.execute();
    } else {
      result = await getDataUsers.execute();
    }
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        if (_listUser.isEmpty) {
          for (int i = 0; i < moviesData.length; i++) {
            saveData.execute(moviesData.elementAt(i));
          }
        }
        _users = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> removeAllData() async {
    _state = RequestState.Loading;
    notifyListeners();

    var result;
    for (int i = 0; i < _users.length; i++) {
      result = await removeData.execute(_users.elementAt(i));
    }

    await result.fold(
      (failure) async {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (successMessage) async {
        _message = successMessage;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );

    await fetchDataUsers(true);
  }
}
