import 'package:dio/dio.dart';
import 'package:sammychatbot/service/constants.dart';
import 'package:sammychatbot/service/storage_service.dart';

class HttpService {
  static final HttpService _singleton = HttpService._internal();

  final _dio = Dio();

  factory HttpService() {
    return _singleton;
  }
  HttpService._internal() {
    setUp();
  }

  Future<void> setUp({String? bearerToken}) async {
    final headers = {"Content-Type": "Application/json"};

    if (bearerToken != null) {
      headers["Authorization"] = "Bearer $bearerToken";
    }

    final options = BaseOptions(
        baseUrl: API_BASE_URL,
        headers: headers,
        connectTimeout: const Duration(seconds: 15),
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500;
        });

    _dio.options = options;

  }

  Future<Response?> post(String path, Map data, {bool? authenticated}) async {
    _dio.options.baseUrl = 'http://192.168.0.155:8082/api/v1/';
    print(_dio.options.baseUrl + path);

    if (authenticated != null) {

      if (authenticated) {
        String bearerToken = await StorageService().getItem("jwt_token");
        if (bearerToken != null) {
          _dio.options.headers["Authorization"] = "Bearer $bearerToken";
        }
      }
    }

    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      print("error occurred in post method: $e");
    }
    return null;
  }

  Future<Response?> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      print(e);
    }

    return null;
  }
}
