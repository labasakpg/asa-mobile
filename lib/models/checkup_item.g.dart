// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkup_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckupItem _$CheckupItemFromJson(Map<String, dynamic> json) => CheckupItem(
      testCode: json['testCode'] as String,
      name: json['name'] as String?,
      price3: json['price3'] as int?,
      description: json['description'] as String?,
      abbreviation: json['abbreviation'] as String?,
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$CheckupItemToJson(CheckupItem instance) =>
    <String, dynamic>{
      'testCode': instance.testCode,
      'name': instance.name,
      'price3': instance.price3,
      'description': instance.description,
      'abbreviation': instance.abbreviation,
      'key': instance.key,
      'index': instance.index,
    };
