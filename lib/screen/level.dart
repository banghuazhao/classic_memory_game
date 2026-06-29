import 'dart:async';

import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/generated/l10n.dart';
import 'package:classic_memory_game/util/ads_manager.dart';
import 'package:classic_memory_game/util/others.dart';
import 'package:flame_audio/flame_audio.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'flip_card.dart';

// ignore: must_be_immutable
class Levels extends StatefulWidget {
  int level;
  Levels({this.level = 1});
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  // final fireStore = Firebase.initializeApp();

  bool show = true;
  bool choose = false;
  bool restartG = false;
  bool nextLevel = false;
  bool isLoaded = false;
  bool isLoadedIn = false;
  bool allow = true;
  late int _level;
  int? i;
  int ab = 2;
  int? y;
  String q = "";
  String w = "";
  int currentTurns = 0;
  int sec = 700;
  int remainingTime = 0;
  int highScore = 0;
  int highScoreTime = 0;
  List<String> a = [];
  List<String> b = [];

  Timer? timer;
  int gameTime = 0;

  late BannerAd _ad;
  bool _isAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;

  @override
  void initState() {
    _level = widget.level;
    _createInterstitialAd();
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

    super.initState();
    getHighScore();
    first();
    Future.delayed(Duration(milliseconds: 5), () {
      timeLeft();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _ad.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  setHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setInt("l$_level", currentTurns);
    await myPrefs.setInt("t$_level", gameTime);
    getHighScore();
  }

  setPlayerLevel() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setInt("pl", Data.playerLevel);
  }

  getHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final turns = myPrefs.getInt("l$_level");
    final time = myPrefs.getInt("t$_level");
    if (turns != null && time != null) {
      setState(() {
        Data.setLevelScore(_level, turns, time);
      });
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= 3) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) return;
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        AppOpenAdManager.shouldLoadAd = true;
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        AppOpenAdManager.shouldLoadAd = true;
        _createInterstitialAd();
      },
    );
    AppOpenAdManager.shouldLoadAd = false;
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  setRatingSharing() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setBool("rate", Data.rate);
    await myPrefs.setBool("share", Data.share);
  }

  // pairs per level: 1-2=6, 3-6=8, 7-15=10, 16-20=12
  static const _levelPairs = <int, int>{
    1: 6, 2: 6, 3: 8, 4: 8, 5: 8, 6: 8,
    7: 10, 8: 10, 9: 10, 10: 10, 11: 10, 12: 10, 13: 10, 14: 10, 15: 10,
    16: 12, 17: 12, 18: 12, 19: 12, 20: 12,
  };

  first() {
    final pairs = _levelPairs[_level] ?? 10;
    for (int i = 1; i <= pairs; i++) {
      a.add(i.toString());
      a.add(i.toString());
    }
    a.shuffle();
  }

  // Time limits: smooth ramp ~4s/pair (easy) → ~2.5s/pair (hard).
  // L1-2: 6 pairs, L3-6: 8 pairs, L7-15: 10 pairs, L16-20: 12 pairs.
  static const _levelTimeLimit = <int, int>{
    1: 26, 2: 22, 3: 36, 4: 32, 5: 28, 6: 24,
    7: 45, 8: 40, 9: 36, 10: 33, 11: 30, 12: 28, 13: 27, 14: 26, 15: 25,
    16: 48, 17: 44, 18: 40, 19: 36, 20: 32,
  };

  timeLeft() {
    setState(() {
      remainingTime = (_levelTimeLimit[_level] ?? 30) + 3;
      highScore = Data.levelScore(_level);
      highScoreTime = Data.levelTime(_level);
    });
  }

  time() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() { gameTime++; });
      if (gameTime > 8 && remainingTime - gameTime == 0) {
        t.cancel();
        setState(() { allow = false; });
        showWinDialog(S.of(context).Time_is_over);
      }
    });
  }

  bool get _gameInProgress => a.isNotEmpty && b.length < a.length;

  Future<void> _confirmExit() async {
    if (!_gameInProgress) { Navigator.of(context).pop(); return; }
    timer?.cancel();
    final quit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Quit game?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Your progress on this level will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Continue playing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Quit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (quit == true) {
      if (mounted) Navigator.of(context).pop();
    } else {
      // resume timer if game is still running
      if (_gameInProgress && allow) time();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth > 500 ? screenWidth * 0.2 : 20;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _confirmExit(); },
      child: Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _confirmExit,
        ),
        title: Text(
          S.of(context).Level + " ${_level}",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          if (currentTurns >= 1)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: MaterialButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                color: MyColors.cardBackground,
                splashColor: MyColors.mainText,
                height: 36,
                minWidth: 36,
                onPressed: () {
                  showRestart(S.of(context).Restart + "?");
                  setState(() {
                    restartG = true;
                    choose = false;
                  });
                },
                child: Icon(
                  Icons.refresh_rounded,
                  size: 26,
                  color: MyColors.mainText,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              child: currentTurns >= 1
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            remainingTime - gameTime != 0
                                ? "${remainingTime - gameTime} " + S.of(context).seconds_left
                                : S.of(context).Game_Over,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          highScore == 0
                              ? S.of(context).Remaining_time +
                                  ": $remainingTime " +
                                  S.of(context).seconds
                              : S.of(context).High_Score_in_Level +
                                  " ${_level}\n$highScore " +
                                  S.of(context).turns_in +
                                  " $highScoreTime " +
                                  S.of(context).seconds,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 350),
              top: MediaQuery.of(context).size.height * 0.12,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(sidePadding, 10, sidePadding, 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: a.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (_level <= 2) ? 3 : 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final isMatched = b.contains(a[index]);
                    final isRevealed = i == index || y == index;
                    final emoji = Data.categoryMapping[CategoryHelper().category]![int.parse(a[index])];
                    final fontSize = (_level <= 2) ? 50.0 : 40.0;
                    return MemoryCard(
                      isMatched: isMatched,
                      isRevealed: isRevealed,
                      front: Text(emoji, style: TextStyle(fontSize: fontSize)),
                      back: Icon(Icons.help_rounded,
                          size: fontSize, color: MyColors.mainText.withOpacity(0.85)),
                      onTap: () {
                        if (allow == true) {
                          setState(() { choose = false; });
                          if (currentTurns == 0) {
                            time();
                            if (Data.showAds == true) _ad.load();
                          }
                          if (i != index && !isMatched && show == true) {
                            setState(() {
                              currentTurns++;
                              i = index;
                              if (ab % 2 == 0) {
                                y = i;
                                q = a[index].toString();
                              } else {
                                w = a[index].toString();
                                show = false;
                                check();
                              }
                              if (ab % 2 != 0) {
                                Timer(Duration(milliseconds: sec), () {
                                  setState(() { i = null; y = null; show = true; });
                                });
                                sec = 700;
                              }
                              ab++;
                            });
                          }
                        }
                      },
                    );
                  },
                ),
              ),
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
    ), // child: Scaffold
    ); // PopScope
  }

  check() {
    if (q == w) {
      if (Data.soundEffects) {
        FlameAudio.play('match.mp3').then((_) {}, onError: (_, __) {});
      }
      b.add(w);
      b.add(q);
      setState(() {
        sec = 1;
      });
    }

    if (b.length >= a.length) {
      setState(() {
        if (_level <= 19) {
          nextLevel = true;
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        _showInterstitialAd();
      });
      if (_level == Data.playerLevel) {
        Data.playerLevel = _level + 1;
        setPlayerLevel();
      }
      if (_level == 1) {
        if (Data.level_1 != 0) {
          if (currentTurns == Data.level_1) {
            if (gameTime < Data.time_1) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_1) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 2) {
        if (currentTurns == Data.level_2) {
          if (gameTime < Data.time_2) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else if (Data.level_2 != 0) {
          if (currentTurns < Data.level_2) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 3) {
        if (Data.level_3 != 0) {
          if (currentTurns == Data.level_3) {
            if (gameTime < Data.time_3) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_3) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 4) {
        if (Data.level_4 != 0) {
          if (currentTurns == Data.level_4) {
            if (gameTime < Data.time_4) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_4) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 5) {
        if (Data.level_5 != 0) {
          if (currentTurns == Data.level_5) {
            if (gameTime < Data.time_5) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_5) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 6) {
        if (Data.level_6 != 0) {
          if (currentTurns == Data.level_6) {
            if (gameTime < Data.time_6) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_6) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 7) {
        if (Data.level_7 != 0) {
          if (currentTurns == Data.level_7) {
            if (gameTime < Data.time_7) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_7) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 8) {
        if (Data.level_8 != 0) {
          if (currentTurns == Data.level_8) {
            if (gameTime < Data.time_8) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_8) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 9) {
        if (Data.level_9 != 0) {
          if (currentTurns == Data.level_9) {
            if (gameTime < Data.time_9) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_9) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 10) {
        if (Data.level_10 != 0) {
          if (currentTurns == Data.level_10) {
            if (gameTime < Data.time_10) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_10) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 11) {
        if (Data.level_11 != 0) {
          if (currentTurns == Data.level_11) {
            if (gameTime < Data.time_11) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_11) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 12) {
        if (Data.level_12 != 0) {
          if (currentTurns == Data.level_12) {
            if (gameTime < Data.time_12) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_12) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 13) {
        if (Data.level_13 != 0) {
          if (currentTurns == Data.level_13) {
            if (gameTime < Data.time_13) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_13) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 14) {
        if (Data.level_14 != 0) {
          if (currentTurns == Data.level_14) {
            if (gameTime < Data.time_14) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_14) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 15) {
        if (Data.level_15 != 0) {
          if (currentTurns == Data.level_15) {
            if (gameTime < Data.time_15) {
              showWinDialog("   " +
                  S.of(context).New_High_Score +
                  "\n"
                      "$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              setHighScore();
              timer?.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_15) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $gameTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $gameTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        }
      } else if (_level == 16) {
        if (Data.level_16 != 0) {
          if (currentTurns == Data.level_16) {
            if (gameTime < Data.time_16) {
              showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              setHighScore(); timer?.cancel();
            } else {
              showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_16) {
            showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore(); timer?.cancel();
          } else {
            showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
          setHighScore(); timer?.cancel();
        }
      } else if (_level == 17) {
        if (Data.level_17 != 0) {
          if (currentTurns == Data.level_17) {
            if (gameTime < Data.time_17) {
              showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              setHighScore(); timer?.cancel();
            } else {
              showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_17) {
            showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore(); timer?.cancel();
          } else {
            showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
          setHighScore(); timer?.cancel();
        }
      } else if (_level == 18) {
        if (Data.level_18 != 0) {
          if (currentTurns == Data.level_18) {
            if (gameTime < Data.time_18) {
              showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              setHighScore(); timer?.cancel();
            } else {
              showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_18) {
            showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore(); timer?.cancel();
          } else {
            showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
          setHighScore(); timer?.cancel();
        }
      } else if (_level == 19) {
        if (Data.level_19 != 0) {
          if (currentTurns == Data.level_19) {
            if (gameTime < Data.time_19) {
              showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              setHighScore(); timer?.cancel();
            } else {
              showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_19) {
            showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore(); timer?.cancel();
          } else {
            showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
          setHighScore(); timer?.cancel();
        }
      } else if (_level == 20) {
        if (Data.level_20 != 0) {
          if (currentTurns == Data.level_20) {
            if (gameTime < Data.time_20) {
              showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              setHighScore(); timer?.cancel();
            } else {
              showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
              timer?.cancel();
            }
          } else if (currentTurns < Data.level_20) {
            showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore(); timer?.cancel();
          } else {
            showWinDialog("$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer?.cancel();
          }
        } else {
          showWinDialog("   " + S.of(context).New_High_Score + "\n$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
          setHighScore(); timer?.cancel();
        }
      }
    }
  }

  restart() {
    setState(() {
      i = null;
      ab = 2;
      y = null;
      q = "";
      w = "";
      currentTurns = 0;
      a = [];
      sec = 700;
      show = true;
      b = [];
      first();
      timeLeft();
      if (gameTime > 0) {
        timer?.cancel();
        gameTime = 0;
      }
      gameTime = 0;
      allow = true;
      restartG = false;
    });
  }

  levelUp() {
    setState(() {
      _level++;
      i = null;
      ab = 2;
      y = null;
      q = "";
      w = "";
      currentTurns = 0;
      a = [];
      sec = 700;
      show = true;
      nextLevel = false;
      allow = true;
      b = [];
      first();
      timeLeft();
      getHighScore();
      if (gameTime > 0) {
        timer?.cancel();
        gameTime = 0;
      }
      gameTime = 0;
      restartG = false;
    });
  }

  showWinDialog(String yo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              yo,
              style: TextStyle(color: MyColors.mainText),
            )),
            backgroundColor: MyColors.cardBackground,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        S.of(context).Cancel,
                        style: TextStyle(
                          fontSize: 21,
                          color: MyColors.mainText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.11,
                  ),
                  nextLevel == false
                      ? MaterialButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: MyColors.mainText,
                          minWidth: 120,
                          height: 50,
                          onPressed: () {
                            restart();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            S.of(context).Restart,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : MaterialButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: MyColors.mainText,
                          minWidth: 140,
                          height: 50,
                          onPressed: () {
                            levelUp();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            S.of(context).Next_Level,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          );
        });
  }

  showRestart(String yo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyColors.cardBackground,
            title: Center(
                child: Text(
              yo,
              style: TextStyle(color: MyColors.mainText),
            )),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        S.of(context).Cancel,
                        style: TextStyle(
                          fontSize: 21,
                          color: MyColors.mainText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.11,
                  ),
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: MyColors.mainText,
                    minWidth: 120,
                    height: 50,
                    onPressed: () {
                      restart();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      S.of(context).Restart,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}
