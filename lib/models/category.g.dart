// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      code: json['code'] as String?,
      name: json['name'] as String?,
      group: json['group'] as String?,
      print: json['print'] as int?,
      sort: json['sort'] as int?,
      nameE: json['nameE'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'group': instance.group,
      'print': instance.print,
      'sort': instance.sort,
      'nameE': instance.nameE,
    };
