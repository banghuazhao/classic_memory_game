import 'dart:async';

import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/generated/l10n.dart';
import 'package:classic_memory_game/screen/level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class Challenges extends StatefulWidget {
  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool choose = false;
  bool pokeSlide = false;
  int title = 0;
  Timer timer;

  int poke1 = 3;
  int poke2 = 1;

  @override
  void initState() {
    super.initState();
    getPlayerLevel();
    timer = Timer.periodic(Duration(milliseconds: 1400), (timer) {
      setState(() {
        pokeSlide = !pokeSlide;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  getPlayerLevel() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (myPrefs.getInt("pl") != null) {
      setState(() {
        Data.playerLevel = myPrefs.getInt("pl");
      });
    }
  }

  snackBar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.background,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget buildLevel(BuildContext context, int level) {
    return GestureDetector(
      onTap: () {
        if (Data.playerLevel >= level) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Levels(
                level: level,
              );
            },
          ));
        } else {
          snackBar(S.of(context).Complete_level +
              " ${Data.playerLevel} " +
              S.of(context).to_unlock_this_level);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
        child: Data.playerLevel >= level
            ? Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      color: MyColors.mainText,
                      size: 27,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      S.of(context).Level + " $level",
                      style: TextStyle(
                          color: MyColors.mainText, fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ))
            : Card(
                color: Color(0xff171717),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 27,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      S.of(context).Level + " $level",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).Levels,
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          // height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                .map((e) => buildLevel(context, e))
                .toList(),
          ),
        ),
      ),
    );
  }
}
