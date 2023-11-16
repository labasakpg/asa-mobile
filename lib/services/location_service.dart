import 'dart:async';

import 'package:dio/dio.dart' show Response;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/system_config_service.dart';

class _CacheLocation {
  DateTime? getLastSetDelay() {
    var date = GetStorage().read('cache-location-last-time');
    if (date == null) {
      return null;
    }

    return DateTime.tryParse(date);
  }

  bool isPass24Minutes() {
    var lastSetDelay = getLastSetDelay();
    if (lastSetDelay == null) {
      return false;
    }
    var isPass24Minutes =
        lastSetDelay.difference(DateTime.now()).inMinutes.abs() > 24;
    return isPass24Minutes;
  }

  Future<int> setDelay(int delay) async {
    await GetStorage().write('cache-location-delay', delay);
    await GetStorage()
        .write('cache-location-last-time', DateTime.now().toString());
    return delay;
  }

  Future<int> getDelay({int? delay}) async {
    var delayCache = GetStorage().read('cache-location-delay');
    if (delayCache == null && delay != null) {
      return await setDelay(delay);
    }

    return delayCache ?? 0;
  }
}

class LocationService extends BaseService {
  final String baseSource = "/tracks";
  final _systemConfigService = Get.put(SystemConfigService());
  final _cacheLocation = _CacheLocation();
  RxBool isLocationEnabled = RxBool(false);

  Future<Response> post(data) => apiService.post('/$baseSource', data);

  Future<Map<String, dynamic>> constructToLocation() async {
    var locationData = await getLocation();
    if (locationData == null) {
      return Map.identity();
    }

    return {
      "longitude": locationData.longitude,
      "latitude": locationData.latitude,
    };
  }

  Future<Map<String, dynamic>> constructToTrack() async {
    var locationData = await getLocation();
    if (locationData == null) {
      return Map.identity();
    }

    return {
      "track": {
        "longitude": locationData.longitude,
        "latitude": locationData.latitude,
      },
    };
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    isLocationEnabled(true);
    if (kDebugMode) {
      print("Permission for location is granted");
    }
    return await location.getLocation();
  }

  Future<int> getDelay() async {
    var res =
        await _systemConfigService.getByKey(SystemConfigOptions.trackLocation);
    var locationDelayInMinutes = int.parse(res.data['data']);
    var delayInMinute = await _cacheLocation.setDelay(locationDelayInMinutes);
    return delayInMinute;
  }

  FutureOr updatePeriodically(LocationData? value) async {
    if (value == null) {
      return;
    }

    int delayInMinute = 5;
    if (!_cacheLocation.isPass24Minutes()) {
      delayInMinute = await getDelay();
    }
    printInfo(info: "Process location tracker for each $delayInMinute minutes");

    await postLocation();
    var delayDuration = Duration(minutes: delayInMinute);
    Future.delayed(
      delayDuration,
      () async {
        if (_cacheLocation.isPass24Minutes()) {
          delayInMinute = await getDelay();
          delayDuration = Duration(minutes: delayInMinute);
        }

        await postLocation();
      },
    );
  }

  Future postLocation() async {
    var locationPayload = await constructToLocation();
    return await post(locationPayload);
  }
}
