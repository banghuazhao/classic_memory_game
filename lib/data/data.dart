class Data {
  static int highTurn = 0;
  static int highTime = 0;

  static int level = 1;
  static int con = 1;

  static int level_1 = 0;
  static int level_2 = 0;
  static int level_3 = 0;
  static int level_4 = 0;
  static int level_5 = 0;
  static int level_6 = 0;
  static int level_7 = 0;
  static int level_8 = 0;
  static int level_9 = 0;
  static int level_10 = 0;
  static int level_11 = 0;
  static int level_12 = 0;
  static int level_13 = 0;
  static int level_14 = 0;
  static int level_15 = 0;

  static int time_1 = 0;
  static int time_2 = 0;
  static int time_3 = 0;
  static int time_4 = 0;
  static int time_5 = 0;
  static int time_6 = 0;
  static int time_7 = 0;
  static int time_8 = 0;
  static int time_9 = 0;
  static int time_10 = 0;
  static int time_11 = 0;
  static int time_12 = 0;
  static int time_13 = 0;
  static int time_14 = 0;
  static int time_15 = 0;

  static bool challenge_1 = false;
  static bool challenge_2 = false;
  static bool challenge_3 = false;
  static bool challenge_4 = false;
  static bool challenge_5 = false;
  static bool challenge_6 = false;
  static bool challenge_7 = false;
  static bool challenge_8 = false;
  static bool challenge_9 = false;

  static int playerLevel = 1;

  static bool play = true;
  static bool neverPlay = false;
  static bool bgMusicEnabled = true;
  static String bgMusicTrack = 'Calm';
  static bool soundEffects = true;
  static String music = "";

  static bool showAds = false;

  static bool share = false;
  static bool rate = false;

  static List<String> candy = [
    "",
    "🍬",
    "🍭",
    "🍪",
    "🍫",
    "🍩",
    "🧁",
    "🍰",
    "🍮",
    "🥧",
    "🎂",
  ];

  static List<String> animal = [
    "",
    "🐶",
    "🐱",
    "🐮",
    "🐷",
    "🦊",
    "🐵",
    "🐯",
    "🐰",
    "🐸",
    "🐼",
  ];

  static List<String> fruit = [
    "",
    "🍎",
    "🍐",
    "🍊",
    "🍋",
    "🍉",
    "🍌",
    "🍇",
    "🍓",
    "🥝",
    "🍍",
  ];

  static List<String> emoji = [
    "",
    "😀",
    "😊",
    "😎",
    "😛",
    "😬",
    "🤠",
    "🥵",
    "🥶",
    "😱",
    "🤡",
  ];

  static List<String> number = [
    "",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];

  static List<String> symbol = [
    "",
    "!",
    "?",
    "@",
    "%",
    "&",
    "*",
    "#",
    "^",
    ">",
    "<",
  ];

  static int levelScore(int lvl) {
    switch (lvl) {
      case 1: return level_1; case 2: return level_2; case 3: return level_3;
      case 4: return level_4; case 5: return level_5; case 6: return level_6;
      case 7: return level_7; case 8: return level_8; case 9: return level_9;
      case 10: return level_10; case 11: return level_11; case 12: return level_12;
      case 13: return level_13; case 14: return level_14; case 15: return level_15;
      default: return 0;
    }
  }

  static int levelTime(int lvl) {
    switch (lvl) {
      case 1: return time_1; case 2: return time_2; case 3: return time_3;
      case 4: return time_4; case 5: return time_5; case 6: return time_6;
      case 7: return time_7; case 8: return time_8; case 9: return time_9;
      case 10: return time_10; case 11: return time_11; case 12: return time_12;
      case 13: return time_13; case 14: return time_14; case 15: return time_15;
      default: return 0;
    }
  }

  static void setLevelScore(int lvl, int turns, int time) {
    switch (lvl) {
      case 1: level_1 = turns; time_1 = time; break;
      case 2: level_2 = turns; time_2 = time; break;
      case 3: level_3 = turns; time_3 = time; break;
      case 4: level_4 = turns; time_4 = time; break;
      case 5: level_5 = turns; time_5 = time; break;
      case 6: level_6 = turns; time_6 = time; break;
      case 7: level_7 = turns; time_7 = time; break;
      case 8: level_8 = turns; time_8 = time; break;
      case 9: level_9 = turns; time_9 = time; break;
      case 10: level_10 = turns; time_10 = time; break;
      case 11: level_11 = turns; time_11 = time; break;
      case 12: level_12 = turns; time_12 = time; break;
      case 13: level_13 = turns; time_13 = time; break;
      case 14: level_14 = turns; time_14 = time; break;
      case 15: level_15 = turns; time_15 = time; break;
    }
  }

  static Map<String, List<String>> categoryMapping = {
    "Candy": candy,
    "Fruit": fruit,
    "Animal": animal,
    "Emoji": emoji,
    "Number": number,
    "Symbol": symbol
  };
}
