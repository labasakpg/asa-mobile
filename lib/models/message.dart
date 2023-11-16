import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/picture.dart';

import 'user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int? id;
  final String? body;
  final String? createdAt;
  final String? updatedAt;
  final User? user;
  final Picture? file;
  final int? key;
  final int? index;

  Message({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.file,
    this.key,
    this.index,
  });

  static List<Message> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Message.fromJson(data)).toList();

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
