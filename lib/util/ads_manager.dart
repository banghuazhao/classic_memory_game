import 'dart:io';

import 'package:classic_memory_game/util/ads_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static bool disableAllAdsForScreenshot = false;

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return "ca-app-pub-3940256099942544/6300978111";
      }
      return AdsConfig.androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return "ca-app-pub-3940256099942544/2934735716";
      }
      return AdsConfig.iOSBannerAdUnitId;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get openAdUnitID {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return 'ca-app-pub-3940256099942544/3419835294';
      }
      return AdsConfig.androidOpenAdUnitId;
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return 'ca-app-pub-3940256099942544/5575463023';
      }
      return AdsConfig.iOSOpenAdUnitId;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return AdsConfig.androidInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        if (disableAllAdsForScreenshot) return "";
        return "ca-app-pub-3940256099942544/4411468910";
      }
      return AdsConfig.iOSInterstitialAdUnitId;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static void debugPrintID() {
    assert(() {
      print("bannerAdUnitId: ${AdsManager.bannerAdUnitId}");
      return true;
    }());
  }
}

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool shouldLoadAd = true;

  final Duration maxCacheDuration = Duration(hours: 4);
  DateTime? _appOpenLoadTime;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdsManager.openAdUnitID,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          assert(() { print('AppOpenAd failed to load: $error'); return true; }());
        },
      ),
    );
  }

  bool get isAdAvailable => _appOpenAd != null;

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      loadAd();
      return;
    }
    if (_isShowingAd) return;
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor extends WidgetsBindingObserver {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (state == AppLifecycleState.resumed) {
      if (AppOpenAdManager.shouldLoadAd) {
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
}
