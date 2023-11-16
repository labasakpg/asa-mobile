import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/models/location.dart';
import 'package:anugerah_mobile/models/picture.dart';
import 'package:anugerah_mobile/models/user.dart';

part 'visitation.g.dart';

@JsonSerializable()
class Visitation {
  final int id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? visitingReason;
  final String? feedback;
  final int? userId;
  final String? branchCode;
  final int? locationId;
  final int? picPhotoId;
  final int? signatureId;
  final int? attachmentId;
  final int? createdBy;
  final User? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Branch? branch;
  final Picture? picPhoto;
  final Picture? signature;
  final Picture? attachment;
  final Location? location;
  final User? user;
  final int? key;
  final int? index;

  Visitation({
    required this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.visitingReason,
    this.feedback,
    this.userId,
    this.branchCode,
    this.locationId,
    this.picPhotoId,
    this.signatureId,
    this.attachmentId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.branch,
    this.picPhoto,
    this.signature,
    this.attachment,
    this.location,
    this.user,
    this.key,
    this.index,
  });

  static List<Visitation> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Visitation.fromJson(data)).toList();

  factory Visitation.fromJson(Map<String, dynamic> json) => _$VisitationFromJson(json);

  Map<String, dynamic> toJson() => _$VisitationToJson(this);
}
