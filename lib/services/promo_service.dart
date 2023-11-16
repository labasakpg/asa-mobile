import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class PromoService extends BaseService {
  final String baseSource = "/promos";

  Future<Response> validatePromoCode(String code) => apiService.get('$baseSource/code/$code/validate');
}
