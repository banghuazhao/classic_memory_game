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

class Memory extends StatefulWidget {
  @override
  _MemoryState createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  bool show = true;
  bool restartG = false;
  bool isLoaded = false;
  bool isLoadedIn = false;
  int? i;
  int ab = 2;
  int? y;
  String q = "";
  String w = "";

  int sec = 700;
  List<String> a = [];
  List<String> b = [];

  Timer? timer;

  int currentTurns = 0;
  int currentTime = 0;

  late BannerAd _ad;

  bool _isAdLoaded = false;

  @override
  void initState() {
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
    Data.level = 1;
    first();
    getHighScore();
  }

  @override
  void dispose() {
    timer?.cancel();
    _ad.dispose();
    super.dispose();
  }

  setHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      myPrefs.setInt("highTurn", currentTurns).then((value) {
        myPrefs.setInt("highTime", currentTime).then((value) {
          getHighScore();
        });
      });
    });
  }

  getHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (myPrefs.getInt("highTurn") != null && myPrefs.getInt("highTime") != null) {
      setState(() {
        Data.highTurn = myPrefs.getInt("highTurn")!;
        Data.highTime = myPrefs.getInt("highTime")!;
      });
    }
  }

  first() {
    for (int i = 1;
        Data.level == 1
            ? i <= 2
            : Data.level == 2
                ? i <= 3
                : Data.level == 3
                    ? i <= 6
                    : Data.level == 4
                        ? i <= 8
                        : Data.level == 5
                            ? i <= 10
                            : Data.level == 6
                                ? i <= 10
                                : i <= 10;
        i++) {
      a.add(i.toString());
      a.add(i.toString());
    }
    a.shuffle();
  }

  time() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth > 500 ? screenWidth * 0.15 : 20;
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).Level + " ${Data.level}",
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
                  showWinDialog(S.of(context).Restart + "?");
                  setState(() {
                    restartG = true;
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
              top: MediaQuery.of(context).size.height * 0.035,
              child: currentTurns >= 1
                  ? Row(
                      children: [
                        Text(
                          currentTurns.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            S.of(context).turns,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            currentTime.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            S.of(context).seconds,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          Data.highTurn != 0
                              ? S.of(context).High_Score +
                                  ": \n"
                                      "${Data.highTurn} " +
                                  S.of(context).turns_in +
                                  " ${Data.highTime} " +
                                  S.of(context).seconds
                              : S.of(context).Find_Matching_cards,
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
              top: MediaQuery.of(context).size.height * 0.1,
              height: MediaQuery.of(context).size.height,
              width: Data.level == 1
                  ? MediaQuery.of(context).size.width
                  : Data.level == 2
                      ? MediaQuery.of(context).size.width * 0.8
                      : Data.level == 3
                          ? MediaQuery.of(context).size.width * 0.93
                          : MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(sidePadding, 20, sidePadding, 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: a.length == null ? 0 : a.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Data.level == 1 || Data.level == 2
                        ? 2
                        : Data.level == 3
                            ? 3
                            : Data.level == 4 || Data.level == 5
                                ? 4
                                : 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
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
                                if (mounted) setState(() {
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
                      },
                      child: _buildMemoryCard(index),
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
            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                top: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: LinearProgressIndicator(
                    value: Data.level == 1 ? 0 : Data.level / 6,
                    backgroundColor: Colors.black.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.mainText),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Card _buildMemoryCard(int index) {
    return Card(
        color: b.contains(a[index])
            ? Color(0xff7C8D6E)
            : i == index || y == index
                ? Color(0xff8697A4)
                : MyColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8,
        child: memoryCardText(index));
  }

  memoryCardText(int index) {
    double size = Data.level == 1
        ? 80
        : Data.level == 2
            ? 70
            : Data.level == 3
                ? 60
                : Data.level == 4
                    ? 50
                    : Data.level == 5
                        ? 40
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

    if (b.length >= a.length && Data.level >= 5) {
      if (Data.highTurn != 0) {
        if (currentTurns == Data.highTurn) {
          if (currentTime < Data.highTime) {
            showWinDialog("   " +
                S.of(context).New_High_Score +
                "\n"
                    "$currentTurns " +
                S.of(context).turns_in +
                " $currentTime " +
                S.of(context).seconds);
            setHighScore();
            timer?.cancel();
          } else {
            showWinDialog("$currentTurns " +
                S.of(context).turns_in +
                " $currentTime " +
                S.of(context).seconds);
            timer?.cancel();
          }
        } else if (currentTurns < Data.highTurn) {
          showWinDialog("   " +
              S.of(context).New_High_Score +
              "\n"
                  "$currentTurns " +
              S.of(context).turns_in +
              " $currentTime " +
              S.of(context).seconds);
          setHighScore();
          timer?.cancel();
        } else {
          showWinDialog(
              "$currentTurns " + S.of(context).turns_in + " $currentTime " + S.of(context).seconds);
        }
      } else {
        showWinDialog("   " +
            S.of(context).New_High_Score +
            "\n"
                "$currentTurns " +
            S.of(context).turns_in +
            " $currentTime " +
            S.of(context).seconds);
        setHighScore();
        timer?.cancel();
      }
    } else if (b.length >= a.length) {
      Timer(Duration(milliseconds: 350), () {
        if (mounted) setState(() {
          Data.level++;
          nextLevel();
        });
      });
    }
  }

  restart() {
    setState(() {
      Data.level = 1;
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
      if (currentTime > 0) {
        timer?.cancel();
        currentTime = 0;
      }
      currentTime = 0;
      restartG = false;
    });
  }

  nextLevel() {
    setState(() {
      i = null;
      ab = 2;
      y = null;
      q = "";
      w = "";
      a = [];
      sec = 700;
      show = true;
      b = [];
      first();
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
              style: TextStyle(
                color: MyColors.mainText,
              ),
            )),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
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
                    width: MediaQuery.of(context).size.width * 0.14,
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
