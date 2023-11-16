import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  final int id;
  final String? title;
  final String? description;
  final String? type;

  final String? status;
  final bool? isReadByPatient;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final User? user;
  final int? key;
  final int? index;

  Thread({
    required this.id,
    this.title,
    this.description,
    this.type,
    this.status,
    this.isReadByPatient,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.key,
    this.index,
  });

  bool getStatus() => status != null && status == "ACTIVE";

  bool get isClosed => status != null && status == "CLOSED";

  bool get isRead => isReadByPatient != null && isReadByPatient!;

  static List<Thread> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data)
          .map((data) => Thread.fromJson(data))
          .toList();

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadToJson(this);
}
