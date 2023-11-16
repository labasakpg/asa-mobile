import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class FaqsService extends BaseService {
  final String baseSource = "faqs";

  Future<Response> getAll() => apiService.get('/$baseSource/all');
}
