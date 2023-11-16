// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Visitation _$VisitationFromJson(Map<String, dynamic> json) => Visitation(
      id: json['id'] as int,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      visitingReason: json['visitingReason'] as String?,
      feedback: json['feedback'] as String?,
      userId: json['userId'] as int?,
      branchCode: json['branchCode'] as String?,
      locationId: json['locationId'] as int?,
      picPhotoId: json['picPhotoId'] as int?,
      signatureId: json['signatureId'] as int?,
      attachmentId: json['attachmentId'] as int?,
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] == null
          ? null
          : User.fromJson(json['updatedBy'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      branch: json['branch'] == null
          ? null
          : Branch.fromJson(json['branch'] as Map<String, dynamic>),
      picPhoto: json['picPhoto'] == null
          ? null
          : Picture.fromJson(json['picPhoto'] as Map<String, dynamic>),
      signature: json['signature'] == null
          ? null
          : Picture.fromJson(json['signature'] as Map<String, dynamic>),
      attachment: json['attachment'] == null
          ? null
          : Picture.fromJson(json['attachment'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$VisitationToJson(Visitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'visitingReason': instance.visitingReason,
      'feedback': instance.feedback,
      'userId': instance.userId,
      'branchCode': instance.branchCode,
      'locationId': instance.locationId,
      'picPhotoId': instance.picPhotoId,
      'signatureId': instance.signatureId,
      'attachmentId': instance.attachmentId,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'branch': instance.branch,
      'picPhoto': instance.picPhoto,
      'signature': instance.signature,
      'attachment': instance.attachment,
      'location': instance.location,
      'user': instance.user,
      'key': instance.key,
      'index': instance.index,
    };
