import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/transaction_service.dart';

class TransactionData {
  final String? arrivalConfirmation;
  final String? checkupDate;
  final int? id;
  final String? orderNumber;
  final double? total;
  final String? contactAddress;
  final String? branchName;
  final int? paymentFileId;
  final String? paymentMethod;
  final String? promotionCouponCode;
  final double? promotionCouponValue;
  final String? promotionCouponType;
  final String? transactionStatus;

  TransactionData({
    this.id,
    this.orderNumber,
    this.arrivalConfirmation,
    this.checkupDate,
    this.total,
    this.contactAddress,
    this.branchName,
    this.paymentFileId,
    this.paymentMethod,
    this.promotionCouponCode,
    this.promotionCouponValue,
    this.promotionCouponType,
    this.transactionStatus,
  });

  bool get isBankTransferPaymentPaid {
    if (paymentMethod != "bank_transfer") {
      return true;
    }
    return paymentFileId != null;
  }

  bool get isTransactionStatusCancelled {
    return transactionStatus != null && transactionStatus == 'cancelled';
  }
}

class TransactionHistoryController extends BaseController {
  RxBool isLoading = RxBool(false);
  RxMap<int, Map<int, Transaction>> transactions = RxMap({});
  RxList<TransactionData> transactionsData = RxList.empty();

  final TransactionService _transactionService = Get.put(TransactionService());

  void fetch() {
    wrapperApiCall(
      Future(() async {
        isLoading(true);
        transactionsData = RxList.empty();

        final res = await _transactionService.getAll(QueryService(
          useQuery: true,
          customeQuery: {
            "includeItems": true,
            "includeUserName": true,
            "orderBy": "checkupDate",
            "sortBy": "desc",
          },
          take: 1000,
        ));
        final data = Transaction.toList(res.data['data']);
        for (var transaction in data) {
          _addToTransactionsData(transaction);
          _addToTransactions(transaction);
        }
      }),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
      finallyCallback: () {
        isLoading(false);
      },
    );
  }

  void _addToTransactions(Transaction transaction) {
    Map<int, Transaction> transactionMap = {};

    for (var item in transaction.items) {
      transactionMap.update(
        item.personalData!.id!,
        (value) {
          value.items.add(item);
          return value;
        },
        ifAbsent: () => Transaction(
          relative: Relative(
            id: item.personalDataId,
            personalData: item.personalData,
          ),
          items: {item},
        ),
      );
    }

    transactions.putIfAbsent(transaction.id!, () => transactionMap);
  }

  void _addToTransactionsData(Transaction transaction) {
    int transactionId = transaction.id ?? -1;
    if (transactionId < 0) return;

    var transactionData = TransactionData(
      id: transaction.id,
      arrivalConfirmation: transaction.arrivalConfirmation,
      checkupDate: transaction.checkupDate,
      orderNumber: transaction.orderNumber,
      total: transaction.grandTotal,
      contactAddress: transaction.contactAddress,
      branchName: transaction.branchName,
      paymentFileId: transaction.paymentFileId,
      paymentMethod: transaction.paymentMethod,
      promotionCouponCode: transaction.promotionCouponCode,
      promotionCouponValue: transaction.promotionCouponValue,
      promotionCouponType: transaction.promotionCouponType,
      transactionStatus: transaction.transactionStatus,
    );
    transactionsData.add(transactionData);
  }
}
