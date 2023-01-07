import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/api_result.dart';
import 'generic_cubit_state.dart';

enum Status { empty, loading, failure, success }

enum ApiOperation { select, create, update, delete }


class GenericCubit<T> extends Cubit<GenericCubitState<List<T>>> {
  GenericCubit() : super(GenericCubitState.loading());

  ApiOperation operation = ApiOperation.select;

  _checkFailureOrSuccess(ApiResult failureOrSuccess) {
    failureOrSuccess.when(
      failure: (String failure) {
        emit(GenericCubitState.failure(failure));
      },
      success: (_) {
        emit(GenericCubitState.success(null));
      },
    );
  }

  Future<void> getItems(Future<ApiResult<List<T>>> apiCallback) async {
    emit(GenericCubitState.loading());
    ApiResult<List<T>> failureOrSuccess = await apiCallback;

    failureOrSuccess.when(
      failure: (String failure) {
        emit(GenericCubitState.failure(failure));
      },
      success: (List<T> items) {
        if (items.isEmpty) {
          emit(GenericCubitState.empty());
        } else {
          emit(GenericCubitState.success(items));
        }
      },
    );
  }

  Future<void> createItem(Future<ApiResult> apiCallback) async {
    emit(GenericCubitState.loading());
    ApiResult failureOrSuccess = await apiCallback;
    _checkFailureOrSuccess(failureOrSuccess);
  }

  Future<void> deleteItem(Future<ApiResult> apiCallback) async {
    emit(GenericCubitState.loading());
    ApiResult failureOrSuccess = await apiCallback;
    _checkFailureOrSuccess(failureOrSuccess);
  }

  Future<void> updateItem(Future<ApiResult> apiCallback) async {
    emit(GenericCubitState.loading());
    ApiResult failureOrSuccess = await apiCallback;
    _checkFailureOrSuccess(failureOrSuccess);
  }
}