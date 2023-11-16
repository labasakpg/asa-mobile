import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class PromosService extends BaseService {
  final String baseSource = "/promos";

  Future<Response> getAll(QueryService? query) =>
      apiService.get('$baseSource${query?.convert()}');

  Future<Response> get(String code, QueryService? query) =>
      apiService.get('$baseSource/$code${query?.convert()}');
}
