import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/services/location_service.dart';

class AttendanceController extends BaseController {
  final _locationService = Get.put(LocationService());

  Future<void> clockInHandler() => handler("CLOCK IN");

  Future<void> clockOutHandler() => handler("CLOCK OUT");

  Future<void> handler(String state) async {
    return wrapperApiCall(
      Future(() async {
        var location = await _locationService.constructToLocation();
        var payload = {
          ...location,
          "type": state,
          "timeZone": DateTime.now().timeZoneOffset.inHours,
        };
        var res = await _locationService.post(payload);
        String? messageResponse = res.data['message'];
        if (messageResponse != null) {
          EasyLoading.showInfo(
            messageResponse,
            duration: const Duration(seconds: 5),
            dismissOnTap: true,
          );
        }
      }),
      showSuccess: false,
    );
  }
}
