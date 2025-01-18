import 'package:dio/dio.dart';

class HttpUtils {
  static HttpUtils _instance = HttpUtils._internal();
  factory HttpUtils() {
    return _instance;
  }
  late Dio dio;
  HttpUtils._internal() {
    BaseOptions options = BaseOptions(
        baseUrl: "http://10.0.2.2:8000/",
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {},
        contentType: "application/json: charset=utf-8",
        responseType: ResponseType.json);
    dio = Dio(options);
  }
  Future post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      print("Request URL: ${dio.options.baseUrl}$path");
      var response =
          await dio.post(path, data: data, queryParameters: queryParameters);
      print("Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("DioException occurred: ${e.response?.data}");
      rethrow;
    }
  }
}
