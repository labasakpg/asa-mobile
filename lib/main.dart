// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:anugerah_mobile/controllers/app_controller.dart';
import 'package:anugerah_mobile/widgets/app_root.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // FIREBASE
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await initializeDateFormatting("id_ID", null);

  var showDebug = (dotenv.env['SHOW_DEBUG'] as String) == 'true';

  runApp(App(showDebug: showDebug));

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(dotenv.env['ONE_SIGNAL_APP_ID'] as String);
  await OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addClickListener((event) {
    Get.put(AppController()).handleDeepLink(event.notification);
  });
}

class App extends StatelessWidget {
  const App({
    Key? key,
    this.showDebug = true,
  }) : super(key: key);

  final bool showDebug;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: showDebug,
          enableLog: true,
          title: 'anugerah ${showDebug ? 'Staging' : ''}',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.ibmPlexSansDevanagariTextTheme(),
          ),
          themeMode: ThemeMode.light,
          builder: (context, child) {
            EasyLoading.init();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: EasyLoading.init()(context, child!),
            );
          },
          home: const AppRoot(),
        );
      },
    );
  }
}
