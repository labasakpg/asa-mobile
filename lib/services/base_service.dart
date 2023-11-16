import 'package:get/get.dart';
import 'package:anugerah_mobile/models/auth_data.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/services/auth_service.dart';

class QueryService {
  final int page;
  final int take;
  final String search;
  final List<String>? selects;
  final bool useQuery;
  final String? sortBy;
  final String? orderBy;
  final Map<String, dynamic>? customeQuery;

  QueryService({
    this.page = 1,
    this.take = 10,
    this.selects,
    this.search = "",
    this.useQuery = false,
    this.sortBy,
    this.orderBy,
    this.customeQuery,
  });

  String convert() {
    if (!useQuery) return "";

    String query = "?";

    query += "page=$page&";
    query += "take=$take&";

    if (search.isNotEmpty) {
      query += "search=$search&";
    }

    if (selects != null) {
      query += "selects=${selects?.join(',')}&";
    }
    if (sortBy != null) {
      query += "sortBy=$sortBy&";
    }
    if (orderBy != null) {
      query += "orderBy=$orderBy&";
    }

    customeQuery?.forEach((key, value) => query += "$key=$value&");

    var lastIndex = query.length - 1;
    if (query[lastIndex] == "&") query = query.substring(0, lastIndex);

    return query;
  }
}

class BaseService extends GetxController {
  final ApiService apiService = Get.put(ApiService());
  final AuthService authService = Get.put(AuthService());

  late int userId;
  late AuthData userData;

  @override
  void onReady() {
    super.onReady();
    if (authService.authData.value != null) {
      userId = authService.authData.value!.user!.id!;
      userData = authService.authData.value!;
    }
  }
}
