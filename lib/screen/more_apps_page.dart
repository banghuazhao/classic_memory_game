import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';

import '../generated/l10n.dart';
import 'colors.dart';

class MoreAppsPage extends StatelessWidget {
  const MoreAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MoreAppItem> _items = [];

    var Image_Guru =
        MoreAppItem(Image.asset("assets/app_icons/image_guru.png"), S.of(context).Image_Guru, () {
      OpenStore.instance.open(appStoreId: "1625021625", androidAppBundleId: "");
    });

    var Falling_Block_Puzzle = MoreAppItem(
        Image.asset("assets/app_icons/falling_block_puzzle.png"), S.of(context).Falling_Block_Puzzle, () {
      OpenStore.instance.open(appStoreId: "1609440799", androidAppBundleId: "");
    });

    var TripMark = MoreAppItem(
        Image.asset("assets/app_icons/tripmark.png"), S.of(context).TripMark, () {
      OpenStore.instance
          .open(appStoreId: "6464474080", androidAppBundleId: "");
    });

    var Yes_Habit =
        MoreAppItem(Image.asset("assets/app_icons/yes_habit.png"), S.of(context).Yes_Habit, () {
      OpenStore.instance.open(appStoreId: "1637643734", androidAppBundleId: "");
    });

    var We_Play_Piano = MoreAppItem(
        Image.asset("assets/app_icons/we_play_piano.png"), S.of(context).We_Play_Piano, () {
      OpenStore.instance
          .open(appStoreId: "1625018611", androidAppBundleId: "com.appsbay.we_play_piano");
    });

    var Metronome_Go = MoreAppItem(
        Image.asset("assets/app_icons/metronome_go.png"), S.of(context).Metronome_Go, () {
      OpenStore.instance
          .open(appStoreId: "1635462172", androidAppBundleId: "com.appsbay.metronome_go");
    });


    var World_Weather_Live = MoreAppItem(
        Image.asset("assets/app_icons/world_weather_live.png"), S.of(context).World_Weather_Live,
        () {
      OpenStore.instance
          .open(appStoreId: "1612773646", androidAppBundleId: "com.appsbay.world_weather_live");
    });

    var Shows = MoreAppItem(Image.asset("assets/app_icons/shows.png"), S.of(context).Shows, () {
      OpenStore.instance.open(appStoreId: "1624910011", androidAppBundleId: "com.appsbay.shows");
    });

    var Classical_Music_Box = MoreAppItem(
        Image.asset("assets/app_icons/classical_music_box.png"), S.of(context).Classical_Music_Box,
        () {
      OpenStore.instance
          .open(appStoreId: "1613096431", androidAppBundleId: "com.appsbay.classical_music_box");
    });

    var Money_Tracker = MoreAppItem(
        Image.asset("assets/app_icons/money_tracker.png"), S.of(context).Money_Tracker, () {
      OpenStore.instance.open(appStoreId: "1534244892", androidAppBundleId: "");
    });

    var Sudoku_Lover = MoreAppItem(
        Image.asset("assets/app_icons/sudoku_lover.png"), S.of(context).Sudoku_Lover, () {
      OpenStore.instance
          .open(appStoreId: "1620749798", androidAppBundleId: "com.appsbay.sudoku_lovers");
    });

    var Onlynote =
        MoreAppItem(Image.asset("assets/app_icons/onlynote.png"), S.of(context).Onlynote, () {
      OpenStore.instance.open(appStoreId: "1616516732", androidAppBundleId: "com.appsbay.onlynote");
    });

    var Water_Tracker = MoreAppItem(
        Image.asset("assets/app_icons/water_tracker.png"), S.of(context).Water_Tracker, () {
      OpenStore.instance.open(appStoreId: "1534891702", androidAppBundleId: "");
    });

    var Novels_Hub =
        MoreAppItem(Image.asset("assets/app_icons/novels_hub.png"), S.of(context).Novels_Hub, () {
      OpenStore.instance
          .open(appStoreId: "1528820845", androidAppBundleId: "com.appsbay.novelshub");
    });

    var SwiftSum = MoreAppItem(
        Image.asset("assets/app_icons/simple_calculator.png"), S.of(context).SwiftSum, () {
      OpenStore.instance
          .open(appStoreId: "1610829871", androidAppBundleId: "com.appsbay.simple_calculator");
    });

    var minesweeper_go = MoreAppItem(
        Image.asset("assets/app_icons/minesweeper_go.png"), S.of(context).Minesweeper_Go, () {
      OpenStore.instance
          .open(appStoreId: "1621899572", androidAppBundleId: "com.appsbay.classic_minesweeper");
    });

    var Saving_Ambulance = MoreAppItem(
        Image.asset("assets/app_icons/saving_ambulance.png"), S.of(context).Saving_Ambulance, () {
      OpenStore.instance
          .open(appStoreId: "1639693525", androidAppBundleId: "com.appsbay.saving_ambulance");
    });

    var Fling_Knife =
        MoreAppItem(Image.asset("assets/app_icons/fling_knife.png"), S.of(context).Fling_Knife, () {
      OpenStore.instance
          .open(appStoreId: "1636426217", androidAppBundleId: "com.appsbay.fling_knife");
    });

    if (Platform.isIOS) {
      _items = [
        Falling_Block_Puzzle,
        TripMark,
        SwiftSum,
        Yes_Habit,
        We_Play_Piano,
        minesweeper_go,
        Saving_Ambulance,
        Metronome_Go,
        Fling_Knife,
        World_Weather_Live,
        Shows,
        Classical_Music_Box,
        Money_Tracker,
        Sudoku_Lover,
        Onlynote,
        Water_Tracker,
        Novels_Hub,
        Image_Guru
      ];
    } else {
      _items = [
        We_Play_Piano,
        minesweeper_go,
        Saving_Ambulance,
        Fling_Knife,
        Metronome_Go,
        World_Weather_Live,
        Shows,
        Classical_Music_Box,
        Sudoku_Lover,
        Onlynote,
        Novels_Hub,
        SwiftSum
      ];
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).More_Apps,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // elevation: 0,
          backgroundColor: MyColors.background,
        ),
        backgroundColor: MyColors.background,
        body: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return MoreAppsRow.factory(_items[index]);
              },
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}

class MoreAppItem {
  Image appIcon;
  String title;
  void Function() onTap;

  MoreAppItem(this.appIcon, this.title, this.onTap);
}

class MoreAppsRow extends StatelessWidget {
  final Image appIcon;
  final IconData trailingIcon;
  final String title;
  final void Function() onTap;

  const MoreAppsRow(
      {super.key,
      this.trailingIcon = Icons.chevron_right_rounded,
      required this.appIcon,
      required this.title,
      required this.onTap});

  MoreAppsRow.factory(MoreAppItem moreAppItem)
      : appIcon = moreAppItem.appIcon,
        trailingIcon = Icons.chevron_right_rounded,
        title = moreAppItem.title,
        onTap = moreAppItem.onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onTap: onTap,
        child: ListTile(
          visualDensity: VisualDensity(vertical: 4), // to compact
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 50,
              width: 50,
              child: appIcon,
            ),
          ),
          trailing: Icon(trailingIcon),
          title: Text(
            title,
          ),
        ),
      ),
    );
  }
}
