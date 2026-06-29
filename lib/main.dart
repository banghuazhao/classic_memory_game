import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:classic_memory_game/screen/home_screen.dart';
import 'package:classic_memory_game/util/ads_manager.dart';
import 'package:classic_memory_game/util/in_app_reviewer_helper.dart';
import 'package:classic_memory_game/util/others.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    await SharedPreferencesHelper.init();

    InAppReviewHelper.checkAndAskForReview();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(MaterialApp(
      title: "Classic Memory Game",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportLocales) {
        if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            return const Locale('zh', 'HK');
          } else {
            return const Locale('zh', '');
          }
        }
        return Locale('en', '');
      },
      theme: ThemeData(
        primaryColor: Color(0xffC850C0),
      ),
      home: HomeScreen(),
    ));
  }, (error, stack) {
    debugPrint('Unhandled error: $error\n$stack');
  });
}

/// Call this after the first frame is drawn (from HomeScreen.initState via
/// addPostFrameCallback). It requests ATT, waits for the result, then
/// initializes MobileAds so ads are always loaded with consent info.
Future<void> initAds() async {
  AdsManager.debugPrintID();

  // Request ATT on iOS — must happen after UI is visible so the user has
  // context. On Android or if already determined, this is a no-op.
  await AppTrackingTransparency.requestTrackingAuthorization();

  // Initialize MobileAds only after ATT is resolved so Google can pass
  // the correct consent signals to ad networks.
  await MobileAds.instance.initialize();
}
