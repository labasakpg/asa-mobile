// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkup_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckupResult _$CheckupResultFromJson(Map<String, dynamic> json) =>
    CheckupResult(
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      checkUpDate: json['checkUpDate'] as String?,
      description: json['description'] as String?,
      doctorId: json['doctorId'] as String?,
      createdAt: json['createdAt'] as String?,
      instituteId: json['instituteId'] as String?,
      key: json['key'] as String?,
      index: json['index'] as int?,
      patient: json['patient'] == null
          ? null
          : Patient.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckupResultToJson(CheckupResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'checkUpDate': instance.checkUpDate,
      'description': instance.description,
      'doctorId': instance.doctorId,
      'createdAt': instance.createdAt,
      'instituteId': instance.instituteId,
      'key': instance.key,
      'index': instance.index,
      'patient': instance.patient,
    };
