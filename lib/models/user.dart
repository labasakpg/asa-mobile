import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/access_menu.dart';
import 'package:anugerah_mobile/models/personal_data.dart';
import 'package:anugerah_mobile/models/role.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? name;
  final String? email;
  final List<Role> roles;
  final List<AccessMenu> accessMenu;
  final PersonalData? personalData;
  final bool asPatient;

  User({
    this.id,
    this.roles = const [],
    this.accessMenu = const [],
    this.name,
    this.email,
    this.personalData,
    this.asPatient = true,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
