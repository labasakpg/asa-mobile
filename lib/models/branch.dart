import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/location.dart';
import 'package:anugerah_mobile/models/picture.dart';

part 'branch.g.dart';

@JsonSerializable()
class Branch {
  final int? key;
  final int? index;
  final String code;
  final String? name;
  final String? address;
  final String? city;
  final Picture? picture;
  final Location? location;
  final String? phoneNumber;
  final int? autoLocation;
  final String? logo;
  final String? icon;
  final String? description;

  Branch({
    this.key,
    this.index,
    required this.code,
    this.name,
    this.address,
    this.city,
    this.phoneNumber,
    this.autoLocation,
    this.logo,
    this.icon,
    this.description,
    this.picture,
    this.location,
  });

  static List<Branch> toListBranchs(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Branch.fromJson(data)).toList();

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

  Map<String, dynamic> toJson() => _$BranchToJson(this);
}
