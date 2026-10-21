import 'package:dio/dio.dart';
import 'package:lumiere/core/network/api_error.dart';

Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiError.fromDioException(e);
  } on ApiError {
    rethrow;
  } catch (_) {
    throw const ApiError(message: 'Something went wrong, please try again');
  }
}