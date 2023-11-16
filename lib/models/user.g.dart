// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      accessMenu: (json['accessMenu'] as List<dynamic>?)
              ?.map((e) => AccessMenu.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String?,
      email: json['email'] as String?,
      personalData: json['personalData'] == null
          ? null
          : PersonalData.fromJson(json['personalData'] as Map<String, dynamic>),
      asPatient: json['asPatient'] as bool? ?? true,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'roles': instance.roles,
      'accessMenu': instance.accessMenu,
      'personalData': instance.personalData,
      'asPatient': instance.asPatient,
    };
