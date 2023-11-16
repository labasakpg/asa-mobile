import 'package:dio/dio.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class VisitationsService extends BaseService {
  final String baseSource = "/visits";

  Future<Response> post(EmployeeStakeHolderState key, data) =>
      apiService.post('$baseSource/${buildKey(key)}', data);

  Future<Response> patch(EmployeeStakeHolderState key, int id, data) =>
      apiService.patch('$baseSource/${buildKey(key)}/$id', data);

  Future<Response> get(EmployeeStakeHolderState key, int id, QueryService? query) =>
      apiService.get('$baseSource/${buildKey(key)}/$id${query?.convert()}');

  Future<Response> getAll(EmployeeStakeHolderState key, QueryService? query) =>
      apiService.get('$baseSource/${buildKey(key)}${query?.convert()}');

  String buildKey(EmployeeStakeHolderState employeeMenu) {
    switch (employeeMenu) {
      case EmployeeStakeHolderState.doctor:
        return "doctors";
      case EmployeeStakeHolderState.institute:
        return "institutes";
      default:
        return "";
    }
  }
}
