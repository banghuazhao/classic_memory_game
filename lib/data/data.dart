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

  static Map<String, List<String>> categoryMapping = {
    "Candy": candy,
    "Fruit": fruit,
    "Animal": animal,
    "Emoji": emoji,
    "Number": number,
    "Symbol": symbol
  };
}
