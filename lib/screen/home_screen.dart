import 'dart:async';

import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/generated/l10n.dart';
import 'package:classic_memory_game/screen/challenges.dart';
import 'package:classic_memory_game/screen/memoryGame.dart';
import 'package:classic_memory_game/util/ads_manager.dart';
import 'package:classic_memory_game/util/audio_manager.dart';
import 'package:classic_memory_game/util/others.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'challenges_page.dart';
import 'colors.dart';
import 'more_apps_page.dart';
import 'settings_page.dart';

const int maxFailedLoadAttempts = 3;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final fireStore = Firebase.initializeApp();

  bool change = false;
  Timer? timer;
  AppLifecycleReactor? _appLifecycleReactor;

  bool newGame = false;
  bool level = false;
  bool challenges = false;
  bool highScore = false;

  String _category = "Candy";

  late BannerAd _ad;

  bool _isAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdsManager.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() { _isAdLoaded = true; });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _ad.load();

    getHighScore();
    WidgetsBinding.instance.addObserver(this);
    // musicName();
    // showAds();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    WidgetsBinding.instance.addObserver(_appLifecycleReactor!);

    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdsManager.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        }));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) return;
    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      AppOpenAdManager.shouldLoadAd = true;
      _createInterstitialAd();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      AppOpenAdManager.shouldLoadAd = true;
      _createInterstitialAd();
    });
    AppOpenAdManager.shouldLoadAd = false;
    _interstitialAd!.show();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        AudioManager.instance.pause();
        break;
      case AppLifecycleState.resumed:
        AudioManager.instance.resume();
        break;
      default:
        break;
    }
  }

  getHighScore() async {
    if (!mounted) return;
    await AudioManager.instance.init();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    _ad.dispose();
    _interstitialAd?.dispose();
    if (_appLifecycleReactor != null) {
      WidgetsBinding.instance.removeObserver(_appLifecycleReactor!);
    }
    super.dispose();
  }

  _displayDialog(BuildContext context) async {
    var newCategory = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: MyColors.cardBackground,
          title: Text(
            S.of(context).Choose_Theme_Icons,
            style: TextStyle(fontSize: 26, color: MyColors.mainText),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Candy");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Candy + '\n' + Data.candy.join(""),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Fruit");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Fruit + '\n' + Data.fruit.join(""),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Animal");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Animal + '\n' + Data.animal.join(""),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Emoji");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Emoji + '\n' + Data.emoji.join(""),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Number");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Number + '\n' + Data.number.join(" "),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "Symbol");
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAd();
                });
              },
              child: Text(
                S.of(context).Symbol + '\n' + Data.symbol.join(" "),
                style: TextStyle(fontSize: 20, color: MyColors.mainText),
              ),
            ),
          ],
          elevation: 10,
          //backgroundColor: Colors.green,
        );
      },
    );

    if (newCategory != null) {
      setState(() {
        _category = newCategory;
        CategoryHelper().set(newCategory);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          S.of(context).Memory_Game,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _displayDialog(context);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: Color(0xffFCEADA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            S.of(context).ThemeIcons,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: "Source",
                              fontWeight: FontWeight.w600,
                              color: MyColors.mainText,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              children: [
                                Text((Data.categoryMapping[_category] ?? []).take(6).join(" "),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 35, color: MyColors.mainText)),
                                Text((Data.categoryMapping[_category] ?? []).skip(6).join(" "),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 35, color: MyColors.mainText)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(S.of(context).Tap_to_Change,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17, color: MyColors.mainText)),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Data.level = 1;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Challenges();
                      },
                    ));
                  },
                  onTapDown: (value) {
                    setState(() {
                      newGame = true;
                    });
                  },
                  onTapUp: (value) {
                    setState(() {
                      newGame = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    height: 60,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: MyColors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Center(
                          child: Text(
                        S.of(context).Levels,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Source",
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainText,
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChooseChallenges();
                      },
                    ));
                  },
                  onTapDown: (value) {
                    setState(() {
                      level = true;
                    });
                  },
                  onTapUp: (value) {
                    setState(() {
                      level = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    height: 60,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: Color(0xffFCEADA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Center(
                          child: Text(
                        S.of(context).Challenges,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Source",
                          fontWeight: FontWeight.w600,
                          color: Color(0xff965454),
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Memory();
                      },
                    ));
                  },
                  onTapDown: (value) {
                    setState(() {
                      challenges = true;
                    });
                  },
                  onTapUp: (value) {
                    setState(() {
                      challenges = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    height: 60,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: Color(0xffFCEADA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Center(
                          child: Text(
                        S.of(context).Marathon,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Source",
                          fontWeight: FontWeight.w600,
                          color: Color(0xff965454),
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MoreAppsPage();
                      },
                    ));
                  },
                  onTapDown: (value) {
                    setState(() {});
                  },
                  onTapUp: (value) {
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    height: 60,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: Color(0xffFCEADA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Center(
                          child: Text(
                        S.of(context).More_Apps,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Source",
                          fontWeight: FontWeight.w600,
                          color: Color(0xff965454),
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
            if (_isAdLoaded)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: AdWidget(ad: _ad),
                  height: 50.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
