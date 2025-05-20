import 'package:dio/dio.dart';


class ApiServices {
  final Dio _dio = Dio();

  Future<Response> post({
    required String url,
    required dynamic data,
    required String token,
    Map<String, dynamic>? headers,
    String? contentType,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: headers ??
              {
                'Content-Type': contentType ?? Headers.formUrlEncodedContentType,
                'Authorization': 'Bearer $token',
              },
        ),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  /// GET request
  /// [queryParameters] can be used to pass any ?key=value pairs in the URL.
  Future<Response> get({
    required String url,
    required String token,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? contentType,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ??
              {
                'Content-Type': contentType ?? Headers.jsonContentType,
                'Authorization': 'Bearer $token',
              },
        ),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}

