// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relative.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relative _$RelativeFromJson(Map<String, dynamic> json) => Relative(
      id: json['id'] as int?,
      personalData: json['personalData'] == null
          ? null
          : PersonalData.fromJson(json['personalData'] as Map<String, dynamic>),
      userId: json['userId'] as int?,
      patientId: json['patientId'] as String?,
      personalDataId: json['personalDataId'] as int?,
      patient: json['patient'] == null
          ? null
          : Patient.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelativeToJson(Relative instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'patientId': instance.patientId,
      'personalDataId': instance.personalDataId,
      'personalData': instance.personalData,
      'patient': instance.patient,
    };
