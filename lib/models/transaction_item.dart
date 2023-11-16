import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/checkup_item.dart';
import 'package:anugerah_mobile/models/personal_data.dart';

part 'transaction_item.g.dart';

@JsonSerializable()
class TransactionItem extends CheckupItem {
  final String? patientId;
  final int? personalDataId;
  final String? patientName;
  final String? checkupName;
  final double? price;
  final dynamic discount;
  final dynamic discountRupiah;
  final double? net;
  final PersonalData? personalData;
  bool isEven;

  TransactionItem({
    this.patientId,
    this.personalDataId,
    this.patientName,
    this.checkupName,
    this.price,
    this.discount,
    this.discountRupiah,
    this.net,
    this.personalData,
    this.isEven = true,
    required String testCode,
    String? name,
    int? price3,
    String? description,
    String? abbreviation,
    int? key,
    int? index,
  }) : super(
          testCode: testCode,
          name: checkupName ?? name,
          price3: price?.toInt() ?? price3,
          description: description,
          abbreviation: abbreviation,
          key: key,
          index: index,
        );

  static List<TransactionItem> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => TransactionItem.fromJson(data)).toList();

  factory TransactionItem.fromJson(Map<String, dynamic> json) => _$TransactionItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}
