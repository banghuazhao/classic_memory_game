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

// ignore: must_be_immutable
class ChallengesLevel extends StatefulWidget {
  int challenge = 1;
  String desc = "";
  ChallengesLevel({this.challenge, this.desc});
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
  int i;
  int ab = 2;
  int y;
  String q = "";
  String w = "";
  int numberOfTurns = 0;
  int sec = 700;
  List<String> a = [];
  List<String> b = [];

  Timer timer;
  int gameTime = 0;

  BannerAd _ad;
  bool _isAdLoaded = false;

  InterstitialAd _interstitialAd;
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
    first();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
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
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
    _interstitialAd.show();
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
      }
    });
  }

  first() {
    for (int i = 1; i <= 8; i++) {
      a.add(i.toString());
      a.add(i.toString());
    }
    a.shuffle();
  }

  number(int index) {
    if (index == i || y == index) {
      return Text(Data.categoryMapping[CategoryHelper().category][int.parse(a[index])],
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ));
    } else {
      return Icon(Icons.help_rounded, size: 40, color: MyColors.mainText.withOpacity(0.85));
    }
  }

  time() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        gameTime++;
        if (widget.challenge == 1) {
          if (gameTime >= 32) {
            setState(() {
              timer.cancel();
              allow = false;
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        } else if (widget.challenge == 3) {
          if (gameTime >= 34) {
            setState(() {
              timer.cancel();
              allow = false;
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        } else if (widget.challenge == 4) {
          if (gameTime >= 24) {
            setState(() {
              timer.cancel();
              allow = false;
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        } else if (widget.challenge == 6) {
          if (gameTime >= 26) {
            setState(() {
              timer.cancel();
              allow = false;
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        } else if (widget.challenge == 7) {
          if (gameTime >= 18) {
            setState(() {
              timer.cancel();
              allow = false;
              showWinDialog(S.of(context).Time_is_over);
            });
          }
        } else if (widget.challenge == 9) {
          if (gameTime >= 20) {
            setState(() {
              timer.cancel();
              allow = false;
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
    double sidePadding = screenWidth > 500 ? screenWidth * 0.15 : 10;
    return GestureDetector(
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
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, "back");
            },
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
                      return GestureDetector(
                        onTap: () {
                          if (allow == true) {
                            setState(() {
                              choose = false;
                            });
                            if (numberOfTurns == 0) {
                              if (Data.showAds == true) {
                                _ad.load();
                              }
                              if (widget.challenge != 2) {
                                time();
                              }
                            }
                            if (i != index && !b.contains(a[index]) && show == true) {
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
                          child: Center(
                            child: b.contains(a[index])
                                ? Text(
                                    Data.categoryMapping[CategoryHelper().category]
                                        [int.parse(a[index])],
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                    ))
                                : number(index),
                          ),
                        ),
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
    );
  }

  Text buildChallengeText() {
    String text = "";
    if (widget.challenge == 1) {
      text = "${32 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 2) {
      text = "${46 - numberOfTurns} " + S.of(context).turns_left;
    } else if (widget.challenge == 3) {
      text = "${48 - numberOfTurns} " +
          S.of(context).turns +
          " ${34 - gameTime} " +
          S.of(context).seconds_left;
    } else if (widget.challenge == 4) {
      text = "${24 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 5) {
      text = "${40 - numberOfTurns}  " + S.of(context).turns_left;
    } else if (widget.challenge == 6) {
      text = "${42 - numberOfTurns} " +
          S.of(context).turns +
          " ${26 - gameTime} " +
          S.of(context).seconds_left;
    } else if (widget.challenge == 7) {
      text = "${18 - gameTime} " + S.of(context).seconds_left;
    } else if (widget.challenge == 8) {
      text = "${32 - numberOfTurns}  " + S.of(context).turns_left;
    } else if (widget.challenge == 9) {
      text = "${34 - numberOfTurns} " +
          S.of(context).turns +
          " ${20 - gameTime} " +
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
      FlameAudio.play('match.mp3');
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
          timer.cancel();
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
          timer.cancel();
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
          timer.cancel();
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
          timer.cancel();
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
          timer.cancel();
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
          timer.cancel();
          Data.challenge_9 = true;
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
      if (numberOfTurns >= 46) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 3) {
      if (numberOfTurns >= 48) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 5) {
      if (numberOfTurns >= 40) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 6) {
      if (numberOfTurns >= 42) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 8) {
      if (numberOfTurns >= 32) {
        setState(() {
          allow = false;
          showWinDialog(S.of(context).Turns_are_over);
        });
      }
    } else if (widget.challenge == 9) {
      if (numberOfTurns >= 34) {
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
        if (timer.isActive == true) {
          timer.cancel();
        }
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
