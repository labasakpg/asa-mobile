// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutUs _$AboutUsFromJson(Map<String, dynamic> json) => AboutUs(
      introduction:
          AboutUsContent.fromJson(json['introduction'] as Map<String, dynamic>),
      tagline: AboutUsContent.fromJson(json['tagline'] as Map<String, dynamic>),
      vision: AboutUsContent.fromJson(json['vision'] as Map<String, dynamic>),
      mission: AboutUsContent.fromJson(json['mission'] as Map<String, dynamic>),
      address: AboutUsContent.fromJson(json['address'] as Map<String, dynamic>),
      website: AboutUsContent.fromJson(json['website'] as Map<String, dynamic>),
      phone: AboutUsContent.fromJson(json['phone'] as Map<String, dynamic>),
      whatsapp:
          AboutUsContent.fromJson(json['whatsapp'] as Map<String, dynamic>),
      tiktok: AboutUsContent.fromJson(json['tiktok'] as Map<String, dynamic>),
      instagram:
          AboutUsContent.fromJson(json['instagram'] as Map<String, dynamic>),
      facebook:
          AboutUsContent.fromJson(json['facebook'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AboutUsToJson(AboutUs instance) => <String, dynamic>{
      'introduction': instance.introduction,
      'tagline': instance.tagline,
      'vision': instance.vision,
      'mission': instance.mission,
      'address': instance.address,
      'website': instance.website,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'tiktok': instance.tiktok,
      'instagram': instance.instagram,
      'facebook': instance.facebook,
    };
