import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/generated/l10n.dart';
import 'package:classic_memory_game/screen/Challenges_level.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class ChooseChallenges extends StatefulWidget {
  @override
  _ChooseChallengesState createState() => _ChooseChallengesState();
}

class _ChooseChallengesState extends State<ChooseChallenges> {
  @override
  void initState() {
    super.initState();
    getHighScore();
  }

  getHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (myPrefs.getBool("c1") != null) {
      setState(() {
        Data.challenge_1 = myPrefs.getBool("c1");
      });
    }
    if (myPrefs.getBool("c2") != null) {
      setState(() {
        Data.challenge_2 = myPrefs.getBool("c2");
      });
    }
    if (myPrefs.getBool("c3") != null) {
      setState(() {
        Data.challenge_3 = myPrefs.getBool("c3");
      });
    }
    if (myPrefs.getBool("medium1") != null) {
      setState(() {
        Data.challenge_4 = myPrefs.getBool("medium1");
      });
    }
    if (myPrefs.getBool("medium2") != null) {
      setState(() {
        Data.challenge_5 = myPrefs.getBool("medium2");
      });
    }
    if (myPrefs.getBool("medium3") != null) {
      setState(() {
        Data.challenge_6 = myPrefs.getBool("medium3");
      });
    }
    if (myPrefs.getBool("hard1") != null) {
      setState(() {
        Data.challenge_7 = myPrefs.getBool("hard1");
      });
    }
    if (myPrefs.getBool("hard2") != null) {
      setState(() {
        Data.challenge_8 = myPrefs.getBool("hard2");
      });
    }
    if (myPrefs.getBool("hard3") != null) {
      setState(() {
        Data.challenge_9 = myPrefs.getBool("hard3");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        title: Text(
          S.of(context).Challenges,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            _buildChallengeWidget(context, " " + S.of(context).Challenge_1_Easy,
                S.of(context).Complete_in_32_seconds, 1, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 1,
                    desc: S.of(context).Complete_in_32_seconds,
                  );
                },
              )).then((value) {
                setState(() {
                  getHighScore();
                });
              });
            }),
            _buildChallengeWidget(context, " " + S.of(context).Challenge_2_Easy,
                S.of(context).Complete_in_46_turns, 2, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 2,
                    desc: S.of(context).Complete_in_46_turns,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, " " + S.of(context).Challenge_3_Easy,
                S.of(context).Complete_in_48_turns_and_34_seconds, 3, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 3,
                    desc: S.of(context).Complete_in_48_turns_and_34_seconds,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, "   " + S.of(context).Challenge_4_Medium,
                S.of(context).Complete_in_24_seconds, 4, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 4,
                    desc: S.of(context).Complete_in_24_seconds,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, "   " + S.of(context).Challenge_5_Medium,
                S.of(context).Complete_in_40_turns, 5, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 5,
                    desc: S.of(context).Complete_in_40_turns,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, "   " + S.of(context).Challenge_6_Medium,
                S.of(context).Complete_in_42_turns_and_26_seconds, 6, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 6,
                    desc: S.of(context).Complete_in_42_turns_and_26_seconds,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, "   " + S.of(context).Challenge_7_Hard,
                S.of(context).Complete_in_18_seconds, 7, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 7,
                    desc: S.of(context).Complete_in_18_seconds,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, " " + S.of(context).Challenge_8_Hard,
                S.of(context).Complete_in_32_seconds, 8, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 8,
                    desc: S.of(context).Complete_in_32_seconds,
                  );
                },
              ));
            }),
            _buildChallengeWidget(context, " " + S.of(context).Challenge_9_Hard,
                S.of(context).Complete_in_34_turns_and_20_seconds, 9, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChallengesLevel(
                    challenge: 9,
                    desc: S.of(context).Complete_in_34_turns_and_20_seconds,
                  );
                },
              ));
            }),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildChallengeWidget(
      BuildContext context, String title, String desc, int level, VoidCallback onTap) {
    bool shouldShowPass = false;
    if (level == 1) {
      shouldShowPass = Data.challenge_1;
    } else if (level == 2) {
      shouldShowPass = Data.challenge_2;
    } else if (level == 3) {
      shouldShowPass = Data.challenge_3;
    } else if (level == 4) {
      shouldShowPass = Data.challenge_4;
    } else if (level == 5) {
      shouldShowPass = Data.challenge_5;
    } else if (level == 6) {
      shouldShowPass = Data.challenge_6;
    } else if (level == 7) {
      shouldShowPass = Data.challenge_7;
    } else if (level == 8) {
      shouldShowPass = Data.challenge_8;
    } else if (level == 9) {
      shouldShowPass = Data.challenge_9;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 120,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          color: color(level),
          child: Stack(children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                    child: Text(
                      desc,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (shouldShowPass)
              Positioned(
                left: 10,
                top: 10,
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              )
          ]),
        ),
      ),
    );
  }

  Color color(int level) {
    if ([1, 2, 3].contains(level)) {
      return Color(0xff7C8D6E);
    } else if ([4, 5, 6].contains(level)) {
      return Color(0xffA39A88);
    } else {
      return Color(0xff985455);
    }
  }
}
