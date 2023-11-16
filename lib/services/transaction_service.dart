import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class TransactionService extends BaseService {
  final String baseSource = "/transactions";
  final String v2 = "/v2";

  Future<Response> postV2(data) => apiService.post("$v2$baseSource", data);

  Future<Response> postPaymentV2(data) =>
      apiService.post('$v2$baseSource/payments', data);

  Future<Response> get(int id, QueryService? query) =>
      apiService.get('$baseSource/$id${query?.convert()}');

  Future<Response> getAll(QueryService? query) =>
      apiService.get('$baseSource${query?.convert()}');
}
