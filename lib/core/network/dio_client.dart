import 'package:dio/dio.dart';

import '../../config/env.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'network_checker.dart';

class DioClient {
  DioClient({Dio? dio, NetworkChecker? networkChecker})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: Env.baseUrl)),
      _networkChecker = networkChecker ?? NetworkChecker();

  final Dio _dio;
  final NetworkChecker _networkChecker;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (Env.apiKey.isEmpty) {
      throw const ServerException('Missing OpenWeather API key');
    }

    if (!await _networkChecker.isConnected) {
      throw const ServerException('No internet connection');
    }

    final params = <String, dynamic>{
      'appid': Env.apiKey,
      'units': ApiConstants.defaultUnits,
      ...?queryParameters,
    };

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: params,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    }
  }

  Map<String, dynamic> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    if (statusCode == 200 && data != null) {
      return data;
    }

    if (statusCode == 401) {
      throw const ServerException('Invalid API key (401)');
    }
    if (statusCode == 404) {
      throw const ServerException('City not found (404)');
    }

    throw ServerException('Request failed (${response.statusCode})');
  }

  String _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out';
    }
    if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode;
      if (status == 401) return 'Invalid API key (401)';
      if (status == 404) return 'City not found (404)';
      return 'Server error ($status)';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Network connection failed';
    }
    return e.message ?? 'Unexpected error';
  }
}
