import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class RelativesService extends BaseService {
  final String baseSource = "relatives";

  Future<Response> getAll() => apiService.get('/$baseSource');

  Future<Response> checkPatient({
    required String noReg,
    required String pin,
  }) =>
      apiService.get('/$baseSource/check-patient?noReg=$noReg&pin=$pin');

  Future<Response> createNewRelative(data) =>
      apiService.post('/$baseSource', data);

  Future<Response> removeRelative(int id) =>
      apiService.delete('/$baseSource/$id');

  Future<Response> connectPatient(int id, data) =>
      apiService.post('/$baseSource/$id/connect', data);

  Future<Response> updatePersonalData(int id, data) =>
      apiService.patch('/$baseSource/$id', data);
}
