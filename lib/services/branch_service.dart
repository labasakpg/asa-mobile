import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class BranchService extends BaseService {
  final String baseSource = "branchs";

  Future<Response> getAllWithQuery(QueryService? query) => apiService.get('/$baseSource${query?.convert()}');
  Future<Response> getAll([QueryService? query]) => apiService.get('/$baseSource/all${query?.convert()}');
  Future<Response> get(String code, QueryService? query) => apiService.get('/$baseSource/$code${query?.convert()}');
}
