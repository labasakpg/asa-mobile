import 'package:dio/dio.dart';
import 'package:anugerah_mobile/services/base_service.dart';

enum SystemConfigOptions {
  tnc,
  privacyPolicy,
  trackLocation,
  hidePrice,
  aboutUs,
}

class SystemConfigService extends BaseService {
  final String baseSource = "system-configurations";

  Future<Response> getByKey(SystemConfigOptions key) => apiService.get('/$baseSource/key/${buildKey(key)}');

  String buildKey(SystemConfigOptions option) {
    switch (option) {
      case SystemConfigOptions.tnc:
        return "term-and-condition";
      case SystemConfigOptions.privacyPolicy:
        return "privacy-and-policy";
      case SystemConfigOptions.trackLocation:
        return "track-location";
      case SystemConfigOptions.hidePrice:
        return "hide-price-for-mobile-apps";
      case SystemConfigOptions.aboutUs:
        return "about-us";
      default:
        return "";
    }
  }
}
