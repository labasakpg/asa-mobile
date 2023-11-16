// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promo _$PromoFromJson(Map<String, dynamic> json) => Promo(
      id: json['id'] as int?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      tnc: json['tnc'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      startAt: json['startAt'] as String?,
      expiredAt: json['expiredAt'] as String?,
      bannerId: json['bannerId'] as int?,
      banner: json['banner'] == null
          ? null
          : Picture.fromJson(json['banner'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$PromoToJson(Promo instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'value': instance.value,
      'title': instance.title,
      'description': instance.description,
      'tnc': instance.tnc,
      'startAt': instance.startAt,
      'expiredAt': instance.expiredAt,
      'bannerId': instance.bannerId,
      'banner': instance.banner,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
