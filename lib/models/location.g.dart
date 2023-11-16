// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: json['id'] as int,
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      createdAt: json['createdAt'] as String?,
      branchCode: json['branchCode'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'createdAt': instance.createdAt,
      'branchCode': instance.branchCode,
    };
