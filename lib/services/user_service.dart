import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class UserService extends BaseService {
  Future<Response> getCurrentProfile() => apiService.get('/users/me');

  Future<Response> updateCurrentProfile(data) =>
      apiService.patch('/users/me', data);

  Future<Response> updateCurrentPassword(data) =>
      apiService.patch('/users/me/change-password', data);

  Future<Response> changeStatus(data) =>
      apiService.patch('/users/me/status', data);
}
