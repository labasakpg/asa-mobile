// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalData _$PersonalDataFromJson(Map<String, dynamic> json) => PersonalData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      picture: json['picture'] == null
          ? null
          : Picture.fromJson(json['picture'] as Map<String, dynamic>),
      photo: json['photo'] == null
          ? null
          : Picture.fromJson(json['photo'] as Map<String, dynamic>),
      jobPosition: json['jobPosition'] as String?,
      city: json['city'] as String?,
      gender: json['gender'] as String?,
      job: json['job'] as String?,
      ktp: json['ktp'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$PersonalDataToJson(PersonalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth,
      'address': instance.address,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'picture': instance.picture,
      'photo': instance.photo,
      'jobPosition': instance.jobPosition,
      'city': instance.city,
      'gender': instance.gender,
      'job': instance.job,
      'ktp': instance.ktp,
      'title': instance.title,
    };
