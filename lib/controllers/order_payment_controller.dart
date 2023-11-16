import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/pages/orders/order_finish_payment_page.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/files_service.dart';
import 'package:anugerah_mobile/services/transaction_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class OrderPaymentController extends BaseController {
  RxList<Transaction> transactionsData = RxList([]);
  List<int> transactionIds = [];
  RxMap<int, String> uploadedSlugs = RxMap({});

  final FilesService _filesService = Get.put(FilesService());
  final TransactionService _transactionService = Get.put(TransactionService());

  void fetchTransactionById(List<int> ids) {
    wrapperApiCall(
      Future(() async {
        transactionIds = ids;
        final res = await _transactionService.getAll(QueryService(
          useQuery: true,
          orderBy: 'createdAt',
          sortBy: 'desc',
          customeQuery: {
            "includeUserName": true,
            "includePaymentFile": true,
            "includeItems": true,
            "ids": ids.join(","),
            "limit": 100,
          },
        ));
        final List<Transaction> data = Transaction.toList(res.data['data']);
        transactionsData(data);
      }),
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  void processPaymentTransaction() {
    wrapperApiCall(
      Future(() async {
        var payments = uploadedSlugs.entries
            .map((e) => {
                  "fileSlug": e.value,
                  "transactionId": e.key,
                })
            .toList();
        await _transactionService.postPaymentV2({"payments": payments});
      }),
      showSuccess: true,
      successCallback: () => Get.offAll(() => OrderFinishPaymentPage()),
    );
  }

  void selectFile(int? transactionId) async {
    if (transactionId == null) {
      return;
    }

    var source = await PageHelper.getImageSourceWithDialog(context);
    if (source == null) {
      return;
    }

    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      wrapperApiCall(
        Future(() async {
          var res = await _filesService.upload(
            filePath: file.path,
            filename: file.name,
          );
          if (res.data != null) {
            uploadedSlugs.update(
              transactionId,
              (_) => res.data,
              ifAbsent: () => res.data,
            );
          }
        }),
      );
    }
  }

  Map<int, Transaction> convertToMapTransaction(Transaction transaction) {
    Map<int, Transaction> tempMapTransaction = {};

    for (var item in transaction.items) {
      tempMapTransaction.update(
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

    return tempMapTransaction;
  }
}
