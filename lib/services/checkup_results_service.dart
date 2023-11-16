import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class CheckupResultsService extends BaseService {
  final String baseSource = "checkup-results";

  Future<Response> getByPatientId({
    required String patientId,
    required QueryService query,
  }) =>
      apiService.get('/$baseSource/patient/$patientId${query.convert()}');
}
