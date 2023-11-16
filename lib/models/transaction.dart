import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/picture.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/models/transaction_item.dart';
import 'package:anugerah_mobile/models/user.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  Transaction({
    this.items = const {},
    this.relative,
    this.key,
    this.index,
    this.id,
    this.orderNumber,
    this.doctorId,
    this.patientId,
    this.branchCode,
    this.branchName,
    this.checkupDate,
    this.discountTotal,
    this.subTotal,
    this.bankTransferUniqueNumber,
    this.grandTotal,
    this.grandTotalWithBankTransferUniqueNumber,
    this.paymentMethod,
    this.paymentMethodCode,
    this.contactName,
    this.contactMotherName,
    this.contactPhoneNumber,
    this.contactEmail,
    this.contactAddress,
    this.contactBirthDate,
    this.contactGender,
    this.bloodGroup,
    this.note,
    this.promotionCouponId,
    this.promotionCouponCode,
    this.promotionCouponValue,
    this.promotionCouponType,
    this.promotionCouponDiscountTotal,
    this.arrivalConfirmation,
    this.status,
    this.transactionStatus,
    this.isTrash,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.registered,
    this.userId,
    this.user,
    this.paymentFileId,
    this.paymentFile,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  final String? arrivalConfirmation;
  final int? bankTransferUniqueNumber;
  final String? bloodGroup;
  final String? branchCode;
  final String? branchName;
  final String? checkupDate;
  final String? contactAddress;
  final String? contactBirthDate;
  final String? contactEmail;
  final String? contactGender;
  final String? contactMotherName;
  final String? contactName;
  final String? contactPhoneNumber;
  final String? createdAt;
  final String? createdBy;
  final double? discountTotal;
  final int? doctorId;
  final double? grandTotal;
  final int? grandTotalWithBankTransferUniqueNumber;
  final int? id;
  final int? index;
  final String? isTrash;
  final Set<TransactionItem> items;
  final int? key;
  final String? note;
  final String? orderNumber;
  final String? patientId;
  final Picture? paymentFile;
  final int? paymentFileId;
  final String? paymentMethod;
  final String? paymentMethodCode;
  final String? promotionCouponCode;
  final double? promotionCouponDiscountTotal;
  final int? promotionCouponId;
  final String? promotionCouponType;
  final double? promotionCouponValue;
  final int? registered;
  final Relative? relative;
  final String? status;
  final String? transactionStatus;
  final int? subTotal;
  final String? updatedAt;
  final String? updatedBy;
  final User? user;
  final int? userId;

  static List<Transaction> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data)
          .map((data) => Transaction.fromJson(data))
          .toList();

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  bool get isTransactionStatusCancelled {
    return transactionStatus != null && transactionStatus == 'cancelled';
  }
}
