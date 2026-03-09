import 'dart:io';

class AdHelper {
  // Replace these with your real AdMob unit IDs before publishing
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Google Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Google Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Add more ad units here (interstitial, rewarded, etc) if needed
}
