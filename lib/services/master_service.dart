import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class MasterService extends BaseService {
  final String baseSource = "/master";
  final take = 20;

  Future<Response> getCategories() => apiService.get('$baseSource/categories');

  Future<Response> getGeneralPricesByBranchCode({
    required String branchCode,
    required int page,
    String search = "",
    String subGroup = "",
  }) =>
      apiService.get('$baseSource/general-prices?'
          'branchCode=$branchCode&subGroup=$subGroup&'
          'take=$take&page=$page&search=$search');

  Future<Response> getGeneralPricesByBranchCodeAndCategory(
          String branchCode, String subgroup) =>
      apiService.get(
          '$baseSource/general-prices?branchCode=$branchCode&subGroup=$subgroup&take=$take');

  Future<Response> getTitles() => apiService.get('$baseSource/titles');
}
