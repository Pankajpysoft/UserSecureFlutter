import 'dart:math';

class UsernameGenerator {
  static final _random = Random();

  // ---- Cool Style Word Banks ----
  static const List<String> _coolAdjectives = [
    "Shadow", "Neon", "Cyber", "Storm", "Blaze", "Frost", "Iron",
    "Phantom", "Dark", "Nova", "Quantum", "Hyper", "Ultra", "Omega",
    "Alpha", "Delta", "Turbo", "Stealth", "Nexus", "Void"
  ];
  static const List<String> _coolNouns = [
    "Wolf", "Hawk", "Viper", "Dragon", "Phoenix", "Titan", "Sage",
    "Raven", "Ghost", "Knight", "Blade", "Hunter", "Ranger", "Ninja",
    "Comet", "Spike", "Jet", "Flash", "Pulse", "Strike"
  ];

  // ---- Funny Style Word Banks ----
  static const List<String> _funnyAdjectives = [
    "Fluffy", "Bouncy", "Grumpy", "Silly", "Wobbly", "Sneaky",
    "Chubby", "Dizzy", "Zany", "Goofy", "Wacky", "Klutzy",
    "Sleepy", "Giggly", "Doofy", "Bumbling", "Quirky", "Loopy",
    "Wiggly", "Snappy"
  ];
  static const List<String> _funnyNouns = [
    "Pickle", "Noodle", "Waffle", "Potato", "Penguin", "Muffin",
    "Biscuit", "Nugget", "Pudding", "Pancake", "Blobfish", "Hamster",
    "Platypus", "Squirrel", "Hedgehog", "Jellybean", "Turnip",
    "Gumdrop", "Snickerdoodle", "Bumblebee"
  ];

  // ---- Professional Style Word Banks ----
  static const List<String> _profAdjectives = [
    "Smart", "Elite", "Prime", "Swift", "Sharp", "Clear", "Bold",
    "Pure", "True", "Keen", "Bright", "Expert", "Skilled", "Modern",
    "Focused", "Creative", "Reliable", "Dynamic", "Strategic", "Agile"
  ];
  static const List<String> _profNouns = [
    "Dev", "Coder", "Analyst", "Hacker", "Builder", "Designer",
    "Engineer", "Maker", "Creator", "Strategist", "Manager", "Expert",
    "Consultant", "Advisor", "Architect", "Specialist", "Pro",
    "Executive", "Innovator", "Leader"
  ];

  /// Generate a list of usernames
  static List<String> generate(int count, String style) {
    return List.generate(count, (_) => generateOne(style));
  }

  /// Generate a single username
  static String generateOne(String style) {
    String adjective;
    String noun;

    switch (style) {
      case "Funny":
        adjective = _funnyAdjectives[_random.nextInt(_funnyAdjectives.length)];
        noun = _funnyNouns[_random.nextInt(_funnyNouns.length)];
        break;
      case "Professional":
        adjective = _profAdjectives[_random.nextInt(_profAdjectives.length)];
        noun = _profNouns[_random.nextInt(_profNouns.length)];
        break;
      case "Cool":
      default:
        adjective = _coolAdjectives[_random.nextInt(_coolAdjectives.length)];
        noun = _coolNouns[_random.nextInt(_coolNouns.length)];
        break;
    }

    // 60% chance to append a number suffix (10–999)
    bool addNumber = _random.nextDouble() < 0.6;
    String suffix = addNumber ? (_random.nextInt(990) + 10).toString() : "";

    return "$adjective$noun$suffix";
  }
}
