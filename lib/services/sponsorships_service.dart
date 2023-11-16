import 'package:dio/dio.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';

typedef Converter = EmployeeStakeHolderStateConverter;

class SponsorshipsService extends BaseService {
  final String baseSource = "/sponsorships";

  Future<Response> post(EmployeeStakeHolderState key, data) => apiService.post(
      '$baseSource/${Converter.toKey(key)}', data);

  Future<Response> patch(EmployeeStakeHolderState key, int id, data) =>
      apiService.patch(
          '$baseSource/${Converter.toKey(key)}/$id',
          data);

  Future<Response> get(
          EmployeeStakeHolderState key, int id, QueryService? query) =>
      apiService.get(
          '$baseSource/${Converter.toKey(key)}/$id${query?.convert()}');

  Future<Response> getAll(EmployeeStakeHolderState key, QueryService? query) =>
      apiService.get(
          '$baseSource/${Converter.toKey(key)}${query?.convert()}');
}
