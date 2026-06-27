import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:classic_memory_game/screen/home_screen.dart';
import 'package:classic_memory_game/util/ads_manager.dart';
import 'package:classic_memory_game/util/in_app_reviewer_helper.dart';
import 'package:classic_memory_game/util/others.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlameAudio.loop('bg.mp3');

  Future.delayed(const Duration(seconds: 1), () {
    AppTrackingTransparency.requestTrackingAuthorization();
  });

  MobileAds.instance.initialize();

  AdsManager.debugPrintID();

  InAppReviewHelper.checkAndAskForReview();

  await SharedPreferencesHelper.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MaterialApp(
      title: "Classic Memory Game",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 讲en设置为第一项,没有适配语言时,英语为首选项
      supportedLocales: S.delegate.supportedLocales,
      // 插件目前不完善手动处理简繁体
      localeResolutionCallback: (locale, supportLocales) {
        // 中文 简繁体处理
        if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            return const Locale('zh', 'HK'); //繁体
          } else {
            return const Locale('zh', ''); //简体
          }
        }
        return Locale('en', '');
      },
      theme: ThemeData(
        primaryColor: Color(0xffC850C0),
      ),
      home: HomeScreen(),
    ));
  });
}
