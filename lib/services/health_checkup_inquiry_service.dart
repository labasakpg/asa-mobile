import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class HealthCheckupInquiryService extends BaseService {
  final String baseSource = "threads";

  Future<Response> getAll(QueryService? query) => apiService.get('/$baseSource${query?.convert()}');
  Future<Response> getMessages(int threadId, QueryService? query) =>
      apiService.get('/$baseSource/$threadId/messages${query?.convert()}');
  Future<Response> postMessages(String threadId, data) => apiService.post('/$baseSource/$threadId/messages', data);
  Future<Response> post(data) => apiService.post('/$baseSource', data);
}
