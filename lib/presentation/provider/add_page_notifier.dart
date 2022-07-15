import '../../common/state_enum.dart';
import '../../data/models/data_model.dart';
import '../../domain/usecases/edit.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/save.dart';

class AddPageNotifier extends ChangeNotifier {
  static const successMessage = 'Added success';
  static const editSuccessMessage = 'Edit success';
  final Save addData;
  final Edit editData;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  AddPageNotifier({
    required this.addData,
    required this.editData,
  });

  Future<void> add(DataItem value) async {
    _state = RequestState.Loading;
    notifyListeners();
    var result = await addData.execute(value);

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

  Future<void> edit(DataItem value) async {
    _state = RequestState.Loading;
    notifyListeners();
    var result = await editData.execute(value);

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
}
