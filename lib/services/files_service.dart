import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

class FilesService extends BaseService {
  final String baseSource = "files";

  Future<Response> upload({
    required String filePath,
    required String filename,
  }) async {
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    return apiService.dio.post(
      '/$baseSource/upload',
      data: formData,
      options: apiService.optionsWithAuthentication(),
    );
  }

  Future<Response> uploadBytes({
    required List<int> bytes,
    required String filename,
  }) async {
    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    return apiService.dio.post(
      '/$baseSource/upload',
      data: formData,
      options: apiService.optionsWithAuthentication(),
    );
  }
}
