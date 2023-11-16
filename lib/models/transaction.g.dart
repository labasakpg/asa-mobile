// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      relative: json['relative'] == null
          ? null
          : Relative.fromJson(json['relative'] as Map<String, dynamic>),
      key: json['key'] as int?,
      index: json['index'] as int?,
      id: json['id'] as int?,
      orderNumber: json['orderNumber'] as String?,
      doctorId: json['doctorId'] as int?,
      patientId: json['patientId'] as String?,
      branchCode: json['branchCode'] as String?,
      branchName: json['branchName'] as String?,
      checkupDate: json['checkupDate'] as String?,
      discountTotal: (json['discountTotal'] as num?)?.toDouble(),
      subTotal: json['subTotal'] as int?,
      bankTransferUniqueNumber: json['bankTransferUniqueNumber'] as int?,
      grandTotal: (json['grandTotal'] as num?)?.toDouble(),
      grandTotalWithBankTransferUniqueNumber:
          json['grandTotalWithBankTransferUniqueNumber'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      paymentMethodCode: json['paymentMethodCode'] as String?,
      contactName: json['contactName'] as String?,
      contactMotherName: json['contactMotherName'] as String?,
      contactPhoneNumber: json['contactPhoneNumber'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactAddress: json['contactAddress'] as String?,
      contactBirthDate: json['contactBirthDate'] as String?,
      contactGender: json['contactGender'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      note: json['note'] as String?,
      promotionCouponId: json['promotionCouponId'] as int?,
      promotionCouponCode: json['promotionCouponCode'] as String?,
      promotionCouponValue: (json['promotionCouponValue'] as num?)?.toDouble(),
      promotionCouponType: json['promotionCouponType'] as String?,
      promotionCouponDiscountTotal:
          (json['promotionCouponDiscountTotal'] as num?)?.toDouble(),
      arrivalConfirmation: json['arrivalConfirmation'] as String?,
      status: json['status'] as String?,
      transactionStatus: json['transactionStatus'] as String?,
      isTrash: json['isTrash'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      registered: json['registered'] as int?,
      userId: json['userId'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      paymentFileId: json['paymentFileId'] as int?,
      paymentFile: json['paymentFile'] == null
          ? null
          : Picture.fromJson(json['paymentFile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'arrivalConfirmation': instance.arrivalConfirmation,
      'bankTransferUniqueNumber': instance.bankTransferUniqueNumber,
      'bloodGroup': instance.bloodGroup,
      'branchCode': instance.branchCode,
      'branchName': instance.branchName,
      'checkupDate': instance.checkupDate,
      'contactAddress': instance.contactAddress,
      'contactBirthDate': instance.contactBirthDate,
      'contactEmail': instance.contactEmail,
      'contactGender': instance.contactGender,
      'contactMotherName': instance.contactMotherName,
      'contactName': instance.contactName,
      'contactPhoneNumber': instance.contactPhoneNumber,
      'createdAt': instance.createdAt,
      'createdBy': instance.createdBy,
      'discountTotal': instance.discountTotal,
      'doctorId': instance.doctorId,
      'grandTotal': instance.grandTotal,
      'grandTotalWithBankTransferUniqueNumber':
          instance.grandTotalWithBankTransferUniqueNumber,
      'id': instance.id,
      'index': instance.index,
      'isTrash': instance.isTrash,
      'items': instance.items.toList(),
      'key': instance.key,
      'note': instance.note,
      'orderNumber': instance.orderNumber,
      'patientId': instance.patientId,
      'paymentFile': instance.paymentFile,
      'paymentFileId': instance.paymentFileId,
      'paymentMethod': instance.paymentMethod,
      'paymentMethodCode': instance.paymentMethodCode,
      'promotionCouponCode': instance.promotionCouponCode,
      'promotionCouponDiscountTotal': instance.promotionCouponDiscountTotal,
      'promotionCouponId': instance.promotionCouponId,
      'promotionCouponType': instance.promotionCouponType,
      'promotionCouponValue': instance.promotionCouponValue,
      'registered': instance.registered,
      'relative': instance.relative,
      'status': instance.status,
      'transactionStatus': instance.transactionStatus,
      'subTotal': instance.subTotal,
      'updatedAt': instance.updatedAt,
      'updatedBy': instance.updatedBy,
      'user': instance.user,
      'userId': instance.userId,
    };
