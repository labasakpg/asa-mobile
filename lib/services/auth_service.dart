import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:anugerah_mobile/cons/constant.dart';
import 'package:anugerah_mobile/models/access_menu.dart';
import 'package:anugerah_mobile/models/auth_data.dart';
import 'package:anugerah_mobile/models/role.dart';
import 'package:anugerah_mobile/models/user.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/widgets/app_root.dart';

class AuthService extends GetxController {
  Rx<AuthData?> authData = Rx<AuthData?>(null);

  @override
  void onReady() {
    super.onReady();

    updateAuthData(null);
    if (authData.value == null) {
      printInfo(info: "AccessToken not found");
      return;
    }

    printInfo(info: "AccessToken found. User: ${authData.value?.user?.email}.");
  }

  String? get localAccessToken => GetStorage().read(Constant.accessToken);

  String get welcomeName {
    String? name = GetStorage().read(Constant.userName);
    if (name != null) {
      return name;
    }

    var userName = authData.value?.user!.name;
    if (userName != null) {
      return userName;
    }

    var email = authData.value?.user!.email;
    if (email != null) {
      return email;
    }

    return AppConfiguration.usernameGreetings;
  }

  Future setWelcomeName(String? name) async {
    if (name == null) return;

    await GetStorage().write(Constant.userName, name);
  }

  Future<void> setAuthData(String accessToken, [bool? asPatient]) async {
    if (asPatient != null) {
      await GetStorage().write(Constant.asPatient, asPatient);
    }

    await GetStorage().write(Constant.accessToken, accessToken);
    await GetStorage().remove(Constant.userName);
    updateAuthData(accessToken);
  }

  Future<void> removeAuthData() async {
    await GetStorage().remove(Constant.asPatient);
    await GetStorage().remove(Constant.accessToken);
    await GetStorage().remove(Constant.userName);
    authData.value = null;
    await Get.to(() => const AppRoot());
  }

  void updateAuthData(String? accessToken) async {
    if (accessToken == null) {
      if (localAccessToken != null) {
        accessToken ??= localAccessToken;
      } else {
        return;
      }
    }

    _validateAccessToken(accessToken);

    var data = JwtDecoder.tryDecode(accessToken!);
    if (data == null) {
      throw Exception("Failed to decode accessToken");
    }

    var roles = List<String>.from(data["roles"]);
    var accessMenu = List.from(data["accessMenu"])
        .map((menu) => AccessMenu(menu["key"], menu["label"]))
        .toList();
    bool asPatient = this.asPatient;

    var user = User(
      id: data["id"],
      roles: roles.map((name) => Role(name: name)).toList(),
      accessMenu: accessMenu,
      email: data["email"],
      name: data["name"],
      asPatient: asPatient,
    );

    authData(AuthData(
      authorization: accessToken,
      user: user,
      exp: JwtDecoder.getExpirationDate(accessToken),
    ));
  }

  bool get asPatient {
    var val = GetStorage().read(Constant.asPatient);
    if (val == null) return false;
    return val;
  }

  void _validateAccessToken(String? accessToken) {
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("Invalid accessToken value");
    }

    var isExpired = JwtDecoder.isExpired(accessToken);
    if (isExpired) {
      throw Exception("Failed to set AuthData: isExpired $isExpired");
    }
  }

  Future<bool> isFirstTime() async {
    var isFirstTime = await GetStorage().read(Constant.isFirstTime);
    return isFirstTime ?? true;
  }

  Future<void> setIsFirstTime(bool isFirstTime) async {
    await GetStorage().write(Constant.isFirstTime, isFirstTime);
  }
}
