import 'dart:math';

class PasswordGenerator {
  static const String _uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const String _lowercase = "abcdefghijklmnopqrstuvwxyz";
  static const String _numbers = "0123456789";
  static const String _symbols = "!@#\$%^&*()_+-=[]{}|;':\",./<>?";

  // Use crypto-secure random in Dart via Random.secure()
  static final Random _secureRandom = Random.secure();

  /// Generate a password based on selected options
  static String generate({
    required int length,
    required bool useUppercase,
    required bool useLowercase,
    required bool useNumbers,
    required bool useSymbols,
  }) {
    String pool = "";
    String password = "";

    // Build character pool and ensure at least one char from each selected set
    if (useUppercase) {
      pool += _uppercase;
      password += _uppercase[_secureRandom.nextInt(_uppercase.length)];
    }
    if (useLowercase) {
      pool += _lowercase;
      password += _lowercase[_secureRandom.nextInt(_lowercase.length)];
    }
    if (useNumbers) {
      pool += _numbers;
      password += _numbers[_secureRandom.nextInt(_numbers.length)];
    }
    if (useSymbols) {
      pool += _symbols;
      password += _symbols[_secureRandom.nextInt(_symbols.length)];
    }

    // Fallback if none selected
    if (pool.isEmpty) {
      pool = _uppercase + _lowercase + _numbers;
    }

    // Fill remaining length
    while (password.length < length) {
      password += pool[_secureRandom.nextInt(pool.length)];
    }

    // Shuffle the final string so guaranteed characters aren't all at the start
    return _shuffle(password.substring(0, length));
  }

  /// Fisher-Yates shuffle
  static String _shuffle(String input) {
    List<String> chars = input.split('');
    for (int i = chars.length - 1; i > 0; i--) {
      int j = _secureRandom.nextInt(i + 1);
      String temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }
    return chars.join('');
  }

  /// Calculate password strength
  static String calculateStrength(String password) {
    if (password.isEmpty) return "Weak";

    int score = 0;

    // Length scoring
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Character variety scoring
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

    // Map score to label
    if (score >= 6) return "Strong";
    if (score >= 4) return "Good";
    if (score >= 2) return "Fair";
    return "Weak";
  }

  /// Get a 0-100 strength score for the UI meter
  static double getStrengthScore(String password) {
    String strength = calculateStrength(password);
    switch (strength) {
      case "Strong": return 1.0;
      case "Good": return 0.7;
      case "Fair": return 0.4;
      default: return 0.2;
    }
  }
}
