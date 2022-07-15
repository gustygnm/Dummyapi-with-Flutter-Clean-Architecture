import '../../data/models/data_model.dart';
import '../../common/state_enum.dart';
import '../../domain/usecases/get_data_by_id.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/remove.dart';

class DetailPageNotifier extends ChangeNotifier {
  static const successMessage = 'Removed success';
  final Remove removeData;
  final GetDataById getDataById;

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  late DataItem _data;

  DataItem get data => _data;

  String _message = '';
  String get message => _message;

  DetailPageNotifier({
    required this.removeData,
    required this.getDataById,
  });

  Future<void> remove(DataItem value) async {
    _state = RequestState.Loading;
    notifyListeners();
    var result = await removeData.execute(value);

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
  }

  Future<void> fetchDataById(String id) async {
    _state = RequestState.Loading;
    notifyListeners();
    final result;

    result = await getDataById.execute(id);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _data = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
