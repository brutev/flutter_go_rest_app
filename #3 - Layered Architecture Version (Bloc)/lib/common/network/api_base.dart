import 'package:layered_architecture_bloc/common/network/dio_exception.dart';
import 'package:layered_architecture_bloc/common/network/api_result.dart';
import 'package:layered_architecture_bloc/common/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

abstract class ApiBase<T> {
  final DioClient dioClient = DioClient();
  late final T data;

  Future<ApiResult<bool>> _requestMethodTemplate(
      Future<Response<dynamic>> apiCallback) async {
    try {
      await apiCallback;
      return const ApiResult.success(true);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return ApiResult.failure(errorMessage);
    }
  }

  //Generic method template for create item on server
  Future<ApiResult<bool>> createItem(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for update item on server
  Future<ApiResult<bool>> updateItem(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for delete item from server
  Future<ApiResult<bool>> deleteItem(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for getting data from Api
  Future<ApiResult<List<T>>> getItems(Future<Response<dynamic>> apiCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) async {
    try {
      final Response response = await apiCallback;

      final List<T> dataList = List<T>.from(
        json.decode(json.encode(response.data)).map(
              (item) => getJsonCallback(item),
            ),
      );
      return ApiResult.success(dataList);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return ApiResult.failure(errorMessage);
    }
  }
}
