import 'dart:async';

import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/generated/l10n.dart';
import 'package:classic_memory_game/util/ads_manager.dart';
import 'package:classic_memory_game/util/others.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'flip_card.dart';

// ignore: must_be_immutable
class ChallengesLevel extends StatefulWidget {
  int challenge;
  String desc;
  ChallengesLevel({this.challenge = 1, this.desc = ""});
  @override
  _ChallengesLevelState createState() => _ChallengesLevelState();
}

class _ChallengesLevelState extends State<ChallengesLevel> {
  // final fireStore = Firebase.initializeApp();

  bool show = true;
  bool choose = false;
  bool restartG = false;
  bool allow = true;
  bool isLoaded = false;
  bool isLoadedIn = false;
  int? i;
  int ab = 2;
  int? y;
  String q = "";
  String w = "";
  int numberOfTurns = 0;
  int sec = 700;
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
    first();
  }

  @override
  void dispose() {
    timer?.cancel();
    _ad.dispose();
    _interstitialAd?.dispose();
    super.dispose();
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

  setHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.challenge == 1) {
        myPrefs.setBool("c1", Data.challenge_1);
      } else if (widget.challenge == 2) {
        myPrefs.setBool("c2", Data.challenge_2);
      } else if (widget.challenge == 3) {
        myPrefs.setBool("c3", Data.challenge_3);
      } else if (widget.challenge == 4) {
        myPrefs.setBool("medium1", Data.challenge_4);
      } else if (widget.challenge == 5) {
        myPrefs.setBool("medium2", Data.challenge_5);
      } else if (widget.challenge == 6) {
        myPrefs.setBool("medium3", Data.challenge_6);
      } else if (widget.challenge == 7) {
        myPrefs.setBool("hard1", Data.challenge_7);
      } else if (widget.challenge == 8) {
        myPrefs.setBool("hard2", Data.challenge_8);
      } else if (widget.challenge == 9) {
        myPrefs.setBool("hard3", Data.challenge_9);
      } else if (widget.challenge == 10) {
        myPrefs.setBool("expert1", Data.challenge_10);
      } else if (widget.challenge == 11) {
        myPrefs.setBool("expert2", Data.challenge_11);
      } else if (widget.challenge == 12) {
        myPrefs.setBool("expert3", Data.challenge_12);
      }
    });
  }

  first() {
    final pairs = (widget.challenge >= 10) ? 10 : 8;
    for (int i = 1; i <= pairs; i++) {
      a.add(i.toString());
      a.add(i.toString());
    }
    a.shuffle();
  }

  static const _challengeTimeLimit = <int, int>{
    1: 40, 3: 38, 4: 30, 6: 28, 7: 24, 9: 22,
    10: 20, 12: 18,
  };

  time() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() { gameTime++; });
      final limit = _challengeTimeLimit[widget.challenge];
      if (limit != null && gameTime >= limit) {
        t.cancel();
        setState(() { allow = false; });
        showWinDialog(S.of(context).Time_is_over);
      }
    });
  }

  bool get _gameInProgress => a.isNotEmpty && b.length < a.length;

  Future<void> _confirmExit() async {
    if (!_gameInProgress) { Navigator.pop(context, "back"); return; }
    timer?.cancel();
    final quit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Quit challenge?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Your progress on this challenge will be lost.'),
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
      if (mounted) Navigator.pop(context, "back");
    } else {
      if (_gameInProgress && allow) time();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth > 500 ? screenWidth * 0.15 : 10;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _confirmExit(); },
      child: GestureDetector(
      onTap: () {
        setState(() {
          choose = false;
        });
      },
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
            S.of(context).Challenge + " ${widget.challenge}",
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          actions: [
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
                  showWinDialog(S.of(context).Restart + "?");
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
                child: numberOfTurns >= 1
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: buildChallengeText(),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            widget.desc,
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 350),
                top: MediaQuery.of(context).size.height * 0.135,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(sidePadding, 10, sidePadding, 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: a.length == null ? 0 : a.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final isMatched = b.contains(a[index]);
                      final isRevealed = i == index || y == index;
                      final emoji = Data.categoryMapping[CategoryHelper().category]![int.parse(a[index])];
                      return MemoryCard(
                        isMatched: isMatched,
                        isRevealed: isRevealed,
                        front: Text(emoji, style: const TextStyle(fontSize: 40)),
                        back: Icon(Icons.help_rounded,
                            size: 40, color: MyColors.mainText.withOpacity(0.85)),
                        onTap: () {
                          if (allow == true) {
                            setState(() { choose = false; });
                            if (numberOfTurns == 0) {
                              if (Data.showAds == true) _ad.load();
                              if (widget.challenge != 2) time();
                            }
                            if (i != index && !isMatched && show == true) {
                              setState(() {
                                numberOfTurns++;
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
      ),
    ), // child: GestureDetector
    ); // PopScope
  }

  Text buildChallengeText() {
    String text = "";
    if (widget.challenge == 1) {
      text = "${40 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 2) {
      text = "${40 - numberOfTurns} " + S.of(context).turns_left;
    } else if (widget.challenge == 3) {
      text = "${44 - numberOfTurns} " +
          S.of(context).turns +
          " ${38 - gameTime} " +
          S.of(context).seconds_left;
    } else if (widget.challenge == 4) {
      text = "${30 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 5) {
      text = "${32 - numberOfTurns}  " + S.of(context).turns_left;
    } else if (widget.challenge == 6) {
      text = "${36 - numberOfTurns} " +
          S.of(context).turns +
          " ${28 - gameTime} " +
          S.of(context).seconds_left;
    } else if (widget.challenge == 7) {
      text = "${24 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 8) {
      text = "${26 - numberOfTurns}  " + S.of(context).turns_left;
    } else if (widget.challenge == 9) {
      text = "${30 - numberOfTurns} " +
          S.of(context).turns +
          " ${22 - gameTime} " +
          S.of(context).seconds_left;
    } else if (widget.challenge == 10) {
      text = "${20 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 11) {
      text = "${24 - numberOfTurns} " + S.of(context).turns_left;
    } else if (widget.challenge == 12) {
      text = "${26 - numberOfTurns} " +
          S.of(context).turns +
          " ${18 - gameTime} " +
          S.of(context).seconds_left;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
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
      Future.delayed(const Duration(seconds: 1), () {
        _showInterstitialAd();
      });
      if (widget.challenge == 1) {
        setState(() {
          timer?.cancel();
          Data.challenge_1 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 2) {
        setState(() {
          Data.challenge_2 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $numberOfTurns " +
              S.of(context).turns);
        });
      } else if (widget.challenge == 3) {
        setState(() {
          timer?.cancel();
          Data.challenge_3 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "     $numberOfTurns " +
              S.of(context).turns +
              " $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 4) {
        setState(() {
          timer?.cancel();
          Data.challenge_4 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 5) {
        setState(() {
          Data.challenge_5 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $numberOfTurns " +
              S.of(context).turns);
        });
      } else if (widget.challenge == 6) {
        setState(() {
          timer?.cancel();
          Data.challenge_6 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "     $numberOfTurns " +
              S.of(context).turns +
              " $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 7) {
        setState(() {
          timer?.cancel();
          Data.challenge_7 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 8) {
        setState(() {
          Data.challenge_8 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $numberOfTurns " +
              S.of(context).turns);
        });
      } else if (widget.challenge == 9) {
        setState(() {
          timer?.cancel();
          Data.challenge_9 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "     $numberOfTurns " +
              S.of(context).turns +
              " $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 10) {
        setState(() {
          timer?.cancel();
          Data.challenge_10 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $gameTime " +
              S.of(context).seconds);
        });
      } else if (widget.challenge == 11) {
        setState(() {
          Data.challenge_11 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "        $numberOfTurns " +
              S.of(context).turns);
        });
      } else if (widget.challenge == 12) {
        setState(() {
          timer?.cancel();
          Data.challenge_12 = true;
          setHighScore();
          showWinDialog(S.of(context).Challenge_completed_in +
              " \n "
                  "     $numberOfTurns " +
              S.of(context).turns +
              " $gameTime " +
              S.of(context).seconds);
        });
      }
    }

    if (widget.challenge == 2) {
      if (numberOfTurns >= 40) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 3) {
      if (numberOfTurns >= 44) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 5) {
      if (numberOfTurns >= 32) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 6) {
      if (numberOfTurns >= 36) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 8) {
      if (numberOfTurns >= 26) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 9) {
      if (numberOfTurns >= 30) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 11) {
      if (numberOfTurns >= 24) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 12) {
      if (numberOfTurns >= 26) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
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
      numberOfTurns = 0;
      a = [];
      sec = 700;
      show = true;
      allow = true;
      b = [];
      first();
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
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: MyColors.cardBackground,
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
                  ),
                ],
              ),
            ],
          );
        });
  }
}
