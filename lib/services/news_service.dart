import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class NewsService extends BaseService {
  Future<Response> getAll(QueryService? query) => apiService.get('/news${query?.convert()}');
  Future<Response> get(String code, QueryService? query) => apiService.get('/news/$code${query?.convert()}');
}
