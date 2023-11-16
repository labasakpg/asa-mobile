// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: json['id'] as String?,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth,
      'address': instance.address,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
