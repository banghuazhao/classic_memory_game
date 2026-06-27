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

  late Timer timer;
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
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
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
    super.dispose();
    timer.cancel();
  }

  setHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.level == 1) {
        myPrefs.setInt("l1", currentTurns).then((value) {
          myPrefs.setInt("t1", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 2) {
        myPrefs.setInt("l2", currentTurns).then((value) {
          myPrefs.setInt("t2", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 3) {
        myPrefs.setInt("l3", currentTurns).then((value) {
          myPrefs.setInt("t3", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 4) {
        myPrefs.setInt("l4", currentTurns).then((value) {
          myPrefs.setInt("t4", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 5) {
        myPrefs.setInt("l5", currentTurns).then((value) {
          myPrefs.setInt("t5", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 6) {
        myPrefs.setInt("l6", currentTurns).then((value) {
          myPrefs.setInt("t6", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 7) {
        myPrefs.setInt("l7", currentTurns).then((value) {
          myPrefs.setInt("t7", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 8) {
        myPrefs.setInt("l8", currentTurns).then((value) {
          myPrefs.setInt("t8", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 9) {
        myPrefs.setInt("l9", currentTurns).then((value) {
          myPrefs.setInt("t9", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 10) {
        myPrefs.setInt("l10", currentTurns).then((value) {
          myPrefs.setInt("t10", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 11) {
        myPrefs.setInt("l11", currentTurns).then((value) {
          myPrefs.setInt("t11", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 12) {
        myPrefs.setInt("l12", currentTurns).then((value) {
          myPrefs.setInt("t12", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 13) {
        myPrefs.setInt("l13", currentTurns).then((value) {
          myPrefs.setInt("t13", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 14) {
        myPrefs.setInt("l14", currentTurns).then((value) {
          myPrefs.setInt("t14", gameTime).then((value) {
            getHighScore();
          });
        });
      } else if (widget.level == 15) {
        myPrefs.setInt("l15", currentTurns).then((value) {
          myPrefs.setInt("t15", gameTime).then((value) {
            getHighScore();
          });
        });
      }
    });
  }

  setPlayerLevel() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      myPrefs.setInt("pl", Data.playerLevel);
    });
  }

  getHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (widget.level == 1) {
      if (myPrefs.getInt("l1") != null && myPrefs.getInt("t1") != null) {
        setState(() {
          Data.level_1 = myPrefs.getInt("l1")!;
          Data.time_1 = myPrefs.getInt("t1")!;
        });
      }
    } else if (widget.level == 2) {
      if (myPrefs.getInt("l2") != null && myPrefs.getInt("t2") != null) {
        setState(() {
          Data.level_2 = myPrefs.getInt("l2")!;
          Data.time_2 = myPrefs.getInt("t2")!;
        });
      }
    } else if (widget.level == 3) {
      if (myPrefs.getInt("l3") != null && myPrefs.getInt("t3") != null) {
        setState(() {
          Data.level_3 = myPrefs.getInt("l3")!;
          Data.time_3 = myPrefs.getInt("t3")!;
        });
      }
    } else if (widget.level == 4) {
      if (myPrefs.getInt("l4") != null && myPrefs.getInt("t4") != null) {
        setState(() {
          Data.level_4 = myPrefs.getInt("l4")!;
          Data.time_4 = myPrefs.getInt("t4")!;
        });
      }
    } else if (widget.level == 5) {
      if (myPrefs.getInt("l5") != null && myPrefs.getInt("t5") != null) {
        setState(() {
          Data.level_5 = myPrefs.getInt("l5")!;
          Data.time_5 = myPrefs.getInt("t5")!;
        });
      }
    } else if (widget.level == 6) {
      if (myPrefs.getInt("l6") != null && myPrefs.getInt("t6") != null) {
        setState(() {
          Data.level_6 = myPrefs.getInt("l6")!;
          Data.time_6 = myPrefs.getInt("t6")!;
        });
      }
    } else if (widget.level == 7) {
      if (myPrefs.getInt("l7") != null && myPrefs.getInt("t7") != null) {
        setState(() {
          Data.level_7 = myPrefs.getInt("l7")!;
          Data.time_7 = myPrefs.getInt("t7")!;
        });
      }
    } else if (widget.level == 8) {
      if (myPrefs.getInt("l8") != null && myPrefs.getInt("t8") != null) {
        setState(() {
          Data.level_8 = myPrefs.getInt("l8")!;
          Data.time_8 = myPrefs.getInt("t8")!;
        });
      }
    } else if (widget.level == 9) {
      if (myPrefs.getInt("l9") != null && myPrefs.getInt("t9") != null) {
        setState(() {
          Data.level_9 = myPrefs.getInt("l9")!;
          Data.time_9 = myPrefs.getInt("t9")!;
        });
      }
    } else if (widget.level == 10) {
      if (myPrefs.getInt("l10") != null && myPrefs.getInt("t10") != null) {
        setState(() {
          Data.level_10 = myPrefs.getInt("l10")!;
          Data.time_10 = myPrefs.getInt("t10")!;
        });
      }
    } else if (widget.level == 11) {
      if (myPrefs.getInt("l11") != null && myPrefs.getInt("t11") != null) {
        setState(() {
          Data.level_11 = myPrefs.getInt("l11")!;
          Data.time_11 = myPrefs.getInt("t11")!;
        });
      }
    } else if (widget.level == 12) {
      if (myPrefs.getInt("l12") != null && myPrefs.getInt("t12") != null) {
        setState(() {
          Data.level_12 = myPrefs.getInt("l12")!;
          Data.time_12 = myPrefs.getInt("t12")!;
        });
      }
    } else if (widget.level == 13) {
      if (myPrefs.getInt("l13") != null && myPrefs.getInt("t13") != null) {
        setState(() {
          Data.level_13 = myPrefs.getInt("l13")!;
          Data.time_13 = myPrefs.getInt("t13")!;
        });
      }
    } else if (widget.level == 14) {
      if (myPrefs.getInt("l14") != null && myPrefs.getInt("t14") != null) {
        setState(() {
          Data.level_14 = myPrefs.getInt("l14")!;
          Data.time_14 = myPrefs.getInt("t14")!;
        });
      }
    } else if (widget.level == 15) {
      if (myPrefs.getInt("l15") != null && myPrefs.getInt("t15") != null) {
        setState(() {
          Data.level_15 = myPrefs.getInt("l15")!;
          Data.time_15 = myPrefs.getInt("t15")!;
        });
      }
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
    setState(() {
      myPrefs.setBool("rate", Data.rate);
      myPrefs.setBool("share", Data.share);
    });
  }

  first() {
    for (int i = 1;
        widget.level == 1
            ? i <= 6
            : widget.level == 2
                ? i <= 6
                : widget.level == 3
                    ? i <= 8
                    : widget.level == 4
                        ? i <= 6
                        : widget.level == 5
                            ? i <= 8
                            : widget.level == 6
                                ? i <= 8
                                : widget.level == 7
                                    ? i <= 10
                                    : widget.level == 8
                                        ? i <= 10
                                        : widget.level == 9
                                            ? i <= 10
                                            : i <= 10;
        i++) {
      a.add(i.toString());
      a.add(i.toString());
    }
    a.shuffle();
  }

  timeLeft() {
    var addTime = 3;
    if (widget.level == 1) {
      setState(() {
        remainingTime = 18 + addTime;
        highScore = Data.level_1;
        highScoreTime = Data.time_1;
      });
    } else if (widget.level == 2) {
      setState(() {
        remainingTime = 15 + addTime;
        highScore = Data.level_2;
        highScoreTime = Data.time_2;
      });
    } else if (widget.level == 3) {
      setState(() {
        remainingTime = 20 + addTime;
        highScore = Data.level_3;
        highScoreTime = Data.time_3;
      });
    } else if (widget.level == 4) {
      setState(() {
        remainingTime = 15 + addTime;
        highScore = Data.level_4;
        highScoreTime = Data.time_4;
      });
    } else if (widget.level == 5) {
      setState(() {
        remainingTime = 18 + addTime;
        highScore = Data.level_5;
        highScoreTime = Data.time_5;
      });
    } else if (widget.level == 6) {
      setState(() {
        remainingTime = 22 + addTime;
        highScore = Data.level_6;
        highScoreTime = Data.time_6;
      });
    } else if (widget.level == 7) {
      setState(() {
        remainingTime = 24 + addTime;
        highScore = Data.level_7;
        highScoreTime = Data.time_7;
      });
    } else if (widget.level == 8) {
      setState(() {
        remainingTime = 30 + addTime;
        highScore = Data.level_8;
        highScoreTime = Data.time_8;
      });
    } else if (widget.level == 9) {
      setState(() {
        remainingTime = 34 + addTime;
        highScore = Data.level_9;
        highScoreTime = Data.time_9;
      });
    } else if (widget.level == 10) {
      setState(() {
        remainingTime = 35 + addTime;
        highScore = Data.level_10;
        highScoreTime = Data.time_10;
      });
    } else if (widget.level == 11) {
      setState(() {
        remainingTime = 28 + addTime;
        highScore = Data.level_11;
        highScoreTime = Data.time_11;
      });
    } else if (widget.level == 12) {
      setState(() {
        remainingTime = 24 + addTime;
        highScore = Data.level_12;
        highScoreTime = Data.time_12;
      });
    } else if (widget.level == 13) {
      setState(() {
        remainingTime = 28 + addTime;
        highScore = Data.level_13;
        highScoreTime = Data.time_13;
      });
    } else if (widget.level == 14) {
      setState(() {
        remainingTime = 26 + addTime;
        highScore = Data.level_14;
        highScoreTime = Data.time_14;
      });
    } else if (widget.level == 15) {
      setState(() {
        remainingTime = 30 + addTime;
        highScore = Data.level_15;
        highScoreTime = Data.time_15;
      });
    }
  }

  time() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        gameTime++;
        if (gameTime > 8) {
          if (remainingTime - gameTime == 0) {
            setState(() {
              allow = false;
              timer.cancel();
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth > 500 ? screenWidth * 0.2 : 20;
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).Level + " ${widget.level}",
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
                                  " ${widget.level}\n$highScore " +
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
                  itemCount: a.length == null ? 0 : a.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.level == 1
                        ? 3
                        : widget.level == 2
                            ? 3
                            : widget.level == 3
                                ? 4
                                : widget.level == 4
                                    ? 3
                                    : 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (allow == true) {
                          setState(() {
                            choose = false;
                          });
                          if (currentTurns == 0) {
                            time();
                            if (Data.showAds == true) {
                              _ad.load();
                            }
                          }
                          if (i != index && !b.contains(a[index]) && show == true) {
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
                                  setState(() {
                                    i = null;
                                    y = null;
                                    show = true;
                                  });
                                });
                                sec = 700;
                              }
                              ab++;
                            });
                          }
                        }
                      },
                      child: Card(
                          color: b.contains(a[index])
                              ? Color(0xff7C8D6E)
                              : i == index || y == index
                                  ? Color(0xff8697A4)
                                  : MyColors.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 8,
                          child: memoryCardText(index)),
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
    );
  }

  memoryCardText(int index) {
    double size = widget.level == 1
        ? 50
        : widget.level == 2
            ? 50
            : widget.level == 3
                ? 40
                : widget.level == 4
                    ? 50
                    : 40;
    return Center(
      child: b.contains(a[index])
          ? Text(
              Data.categoryMapping[CategoryHelper().category]![int.parse(a[index])],
              style: TextStyle(
                fontSize: size,
                color: Colors.white,
              ),
            )
          : number(index, size),
    );
  }

  number(int index, double size) {
    if (index == i || y == index) {
      return Text(Data.categoryMapping[CategoryHelper().category]![int.parse(a[index])],
          style: TextStyle(
            fontSize: size,
            color: Colors.white,
          ));
    } else {
      return Icon(Icons.help_rounded, size: size, color: MyColors.mainText.withOpacity(0.85));
    }
  }

  check() {
    if (q == w) {
      FlameAudio.play('match.mp3');
      b.add(w);
      b.add(q);
      setState(() {
        sec = 1;
      });
    }

    if (b.length >= a.length) {
      setState(() {
        if (widget.level <= 14) {
          nextLevel = true;
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        _showInterstitialAd();
      });
      if (widget.level == Data.playerLevel) {
        Data.playerLevel = widget.level + 1;
        setPlayerLevel();
      }
      if (widget.level == 1) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 2) {
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            setHighScore();
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 3) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 4) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 5) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 6) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 7) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 8) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 9) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 10) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 11) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 12) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 13) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 14) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
        }
      } else if (widget.level == 15) {
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
              timer.cancel();
            } else {
              showWinDialog("$currentTurns " +
                  S.of(context).turns_in +
                  " $gameTime " +
                  S.of(context).seconds);
              timer.cancel();
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
            timer.cancel();
          } else {
            showWinDialog(
                "$currentTurns " + S.of(context).turns_in + " $gameTime " + S.of(context).seconds);
            timer.cancel();
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
          timer.cancel();
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
        timer.cancel();
        gameTime = 0;
      }
      gameTime = 0;
      allow = true;
      restartG = false;
    });
  }

  levelUp() {
    setState(() {
      widget.level++;
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
        timer.cancel();
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
