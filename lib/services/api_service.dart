// ignore_for_file: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get/get.dart' hide Response;
import 'package:anugerah_mobile/cons/constant.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService extends GetxController {
  final CacheOptions cacheOptions = CacheOptions(
    store: MemCacheStore(),
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(hours: 1),
  );

  final Dio dio = Dio();
  final Options options = Options(contentType: "application/json");

  final AuthService _authService = Get.put(AuthService());

  @override
  void onReady() {
    super.onReady();
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(
      PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      maxWidth: 100,
      )
    );
    dio.interceptors.add(
      DioCacheInterceptor(
        options: cacheOptions
      )
    );
  }

  String get baseUrl => Constant.baseAPI;

  void updateHeaderOptions({required Map<String, dynamic> headers}) =>
      options.headers = {...?options.headers, ...headers};

  Future<Response> requestOTP(
      {required int phoneNumber, bool asPatient = false}) {
    return dio.post(
      "/auth/request-otp",
      options: Options(contentType: "application/json"),
      data: {
        "phoneNumber": phoneNumber,
        "asPatient": asPatient,
      },
    );
  }

  Future<Response> signIn({
    int? phoneNumber,
    String? otpCode,
    String? email,
    String? password,
    bool asPatient = false,
    Map<String, dynamic>? location,
  }) async {
    Map<String, Object> data = {};
    if (phoneNumber != null) {
      data["phoneNumber"] = phoneNumber;
    }
    if (otpCode != null) {
      data["otpCode"] = otpCode;
    }
    if (email != null) {
      data["email"] = email;
    }
    if (password != null) {
      data["password"] = password;
    }
    if (location != null) {
      data["track"] = location;
    }
    data["asPatient"] = asPatient;

    var payload = _updateWithOneSignalPlayerId(data);
    return dio.post(
      "/auth/sign-in",
      options: Options(contentType: "application/json"),
      data: payload,
    );
  }

  Future<Response> signOut({Map<String, dynamic>? payload}) async {
    payload = _updateWithOneSignalPlayerId(payload);
    return dio.post(
      "/auth/sign-out",
      options: optionsWithAuthentication(),
      data: payload,
    );
  }

  Future<Response> getSystemConfiguratin(String key) =>
      dio.get("/system-configurations/key/$key");

  Future<Response> authenticate({required String token}) {
    final body = {"token": token};
    return dio.post("/authenticate",
        data: body, options: Options(contentType: "application/json"));
  }

  Future<Response> getUser({required Map<String, dynamic> queryParameters}) =>
      dio.get("/user", queryParameters: queryParameters, options: options);

  Future<Response> getUserId(String id,
          {required Map<String, dynamic> queryParameters}) =>
      dio.get("/user/$id", queryParameters: queryParameters, options: options);

  Future<Response> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    return dio.post(
      "/auth/register",
      options: Options(contentType: "application/json"),
      data: {
        "name": username,
        "email": email,
        "password": password,
        "phoneNumber": phone,
      },
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      dio.get(
        path,
        queryParameters: queryParameters,
        options: optionsWithAuthentication(),
      );

  Future<Response> post(
    String path,
    data, {
    Map<String, dynamic>? queryParameters,
  }) =>
      dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: optionsWithAuthentication(),
      );

  Future<Response> patch(
    String path,
    data, {
    Map<String, dynamic>? queryParameters,
  }) =>
      dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: optionsWithAuthentication(),
      );

  Future<Response> delete(String path) => dio.delete(
        path,
        options: optionsWithAuthentication(),
      );

  Options optionsWithAuthentication() {
    if (_authService.authData.value != null &&
        _authService.authData.value?.authorization != null) {
      updateHeaderOptions(headers: {
        "Authorization": "Bearer ${_authService.authData.value?.authorization}",
      });
    }

    return options;
  }

  Map<String, dynamic> _updateWithOneSignalPlayerId(
      Map<String, dynamic>? data) {
    data ??= {};

    data['oneSignalPlayerId'] = OneSignal.User.pushSubscription.id;
    data['platform'] = 'MOBILE';
    return data;
  }
}
