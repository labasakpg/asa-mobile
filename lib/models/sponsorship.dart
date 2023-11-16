import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/models/location.dart';
import 'package:anugerah_mobile/models/picture.dart';
import 'package:anugerah_mobile/models/user.dart';

part 'sponsorship.g.dart';

@JsonSerializable()
class Sponsorship {
  final int id;
  final String? receiptNumber;
  final String? processNumber;
  final String? name;
  final String? picName;
  final String? instituteName;
  final String? address;
  final String? city;
  final int? nominal;
  final int? userId;
  final String? branchCode;
  final int? locationId;
  final int? picPhotoId;
  final int? signatureId;
  final int? createdBy;
  final User? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Branch? branch;
  final Picture? picPhoto;
  final Picture? signature;
  final Location? location;
  final User? user;
  final int? key;
  final int? index;

  Sponsorship({
    required this.id,
    this.name,
    this.picName,
    this.instituteName,
    this.address,
    this.userId,
    this.branchCode,
    this.locationId,
    this.picPhotoId,
    this.signatureId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.branch,
    this.picPhoto,
    this.signature,
    this.location,
    this.user,
    this.key,
    this.index,
    this.receiptNumber,
    this.processNumber,
    this.city,
    this.nominal,
  });

  static List<Sponsorship> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data)
          .map((data) => Sponsorship.fromJson(data))
          .toList();

  factory Sponsorship.fromJson(Map<String, dynamic> json) =>
      _$SponsorshipFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorshipToJson(this);
}
