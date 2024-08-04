import 'package:dio/dio.dart';

import '../local/cache_helper.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.43.15:8000/',
        receiveDataWhenStatusError: true,

      ),
    );
    dio!.options.connectTimeout =
    10000; // Set the connection timeout to 10 seconds
    dio!.options.receiveTimeout = 10000;
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    return await dio!.get(url,
        queryParameters: query,
        options: Options(headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        })
    );
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    // dio!.options.headers =
    // {
    //   'Authorization': "Bearer $token",
    //   'Content-Type': 'application/json',
    // };
    String tokenA ='';
    if(CacheHelper.getData(key: 'token') != null){
      tokenA = CacheHelper.getData(key: 'token');
    }
    return dio!.post(url,
        queryParameters: query,
        data: data,
        options: Options(headers: {
          'Authorization': "Bearer $tokenA",
          "Accept" : "application/json"
        }));
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json',
    };

    return dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {

    return await dio!.delete(
        url,
        queryParameters: query,
        data: data,
        options: Options(headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        })
    );
  }
}
