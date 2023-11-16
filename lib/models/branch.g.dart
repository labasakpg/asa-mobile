// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch(
      key: json['key'] as int?,
      index: json['index'] as int?,
      code: json['code'] as String,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      autoLocation: json['autoLocation'] as int?,
      logo: json['logo'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      picture: json['picture'] == null
          ? null
          : Picture.fromJson(json['picture'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'key': instance.key,
      'index': instance.index,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'picture': instance.picture,
      'location': instance.location,
      'phoneNumber': instance.phoneNumber,
      'autoLocation': instance.autoLocation,
      'logo': instance.logo,
      'icon': instance.icon,
      'description': instance.description,
    };
